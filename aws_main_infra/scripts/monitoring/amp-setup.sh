#!/bin/bash
infrastructure_account_id=$1
infrastructure_profile=$2
eks_name=$3
amp_workspace_name=$4

workspace_exists=false
workspace_id=''
result=$(aws --profile ${infrastructure_profile} amp list-workspaces --alias ${amp_workspace_name})
for k in $(jq '.workspaces | keys | .[]' <<< "$result"); do
  workspace=$(jq -r ".workspaces[$k]" <<< "$result")
  alias=$(jq -r '.alias' <<< "$workspace" | xargs)
  if [[ "${alias}" == "${amp_workspace_name}" ]]; then
    workspace_id=$(jq -r '.workspaceId' <<< "$workspace")
    workspace_exists=true
    break
  fi
done

if [ "$workspace_exists" = false ]; then
  create_result=$(aws --profile ${infrastructure_profile} amp create-workspace --alias ${amp_workspace_name})
  sleep 300s
  workspace_id=$(echo ${create_result} | jq '.workspaceId' | xargs)
fi

function getRoleArn() {
  OUTPUT=$(aws --profile ${infrastructure_profile} iam get-role --role-name $1 --query 'Role.Arn' --output text 2>&1)

  # Check for an expected exception
  if [[ $? -eq 0 ]]; then
    echo $OUTPUT
  elif [[ -n $(grep "NoSuchEntity" <<< $OUTPUT) ]]; then
    echo ""
  else
    >&2 echo $OUTPUT
    return 1
  fi
}

SERVICE_ACCOUNT_AMP_INGEST_NAME=amp-iamproxy-ingest-service-account
SERVICE_ACCOUNT_IAM_AMP_INGEST_ROLE=amp-iamproxy-ingest-role
SERVICE_ACCOUNT_IAM_AMP_INGEST_POLICY=AMPIngestPolicy

SERVICE_ACCOUNT_IAM_AMP_INGEST_ROLE_ARN=$(getRoleArn ${SERVICE_ACCOUNT_IAM_AMP_INGEST_ROLE})
if [ "${SERVICE_ACCOUNT_IAM_AMP_INGEST_ROLE_ARN}" = "" ];
then

  fullurl=$(aws --profile ${infrastructure_profile} eks describe-cluster --name ${eks_name} --query "cluster.identity.oidc.issuer" --output text)
  url=$(echo ${fullurl} | awk -F[/:] '{print $4}')
  echo | openssl s_client -servername ${url} -connect ${url}:443 2>&1 | sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' > cert.pem
  fingerprint=$(openssl x509 -in cert.pem -fingerprint -noout | cut -d '=' -f2)
  fingerprint=$(echo "${fingerprint//:}")
  cat << EOF > create-open-id-connect-provider.json
{
  "Url": "${fullurl}",
  "ClientIDList": [
    "sts.amazonaws.com"
  ],
  "ThumbprintList": [
    "${fingerprint}"
  ]
}
EOF
  aws --profile ${infrastructure_profile} iam create-open-id-connect-provider --cli-input-json file://create-open-id-connect-provider.json || echo "OIDC Provider exists."

  OIDC_PROVIDER=$(aws --profile ${infrastructure_profile} eks describe-cluster --name ${eks_name} --query "cluster.identity.oidc.issuer" --output text | sed -e "s/^https:\/\///")
  read -r -d '' TRUST_RELATIONSHIP <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Federated": "arn:aws:iam::${infrastructure_account_id}:oidc-provider/${OIDC_PROVIDER}"
      },
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Condition": {
        "StringEquals": {
          "${OIDC_PROVIDER}:sub": "system:serviceaccount:kube-system:amp-iamproxy-ingest-service-account"
        }
      }
    }
  ]
}
EOF
  echo "${TRUST_RELATIONSHIP}" > TrustPolicy.json

  cat <<EOF > PermissionPolicyIngest.json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "aps:RemoteWrite",
        "aps:GetSeries",
        "aps:GetLabels",
        "aps:GetMetricMetadata",
        "aps:QueryMetrics",
        "aps:GetSeries",
        "aps:GetLabels",
        "aps:GetMetricMetadata"
      ],
      "Resource": "*"
    }
  ]
}
EOF

  #
  # Create the IAM role for service account
  #
  SERVICE_ACCOUNT_IAM_AMP_INGEST_ROLE_ARN=$(aws --profile ${infrastructure_profile} iam create-role \
  --role-name $SERVICE_ACCOUNT_IAM_AMP_INGEST_ROLE \
  --assume-role-policy-document file://TrustPolicy.json \
  --query "Role.Arn" --output text)
  #
  # Create an IAM permission policy
  #
  SERVICE_ACCOUNT_IAM_AMP_INGEST_ARN=$(aws --profile ${infrastructure_profile} iam create-policy --policy-name $SERVICE_ACCOUNT_IAM_AMP_INGEST_POLICY \
  --policy-document file://PermissionPolicyIngest.json \
  --query 'Policy.Arn' --output text)
  #
  # Attach the required IAM policies to the IAM role created above
  #
  aws --profile ${infrastructure_profile} iam attach-role-policy \
  --role-name $SERVICE_ACCOUNT_IAM_AMP_INGEST_ROLE \
  --policy-arn $SERVICE_ACCOUNT_IAM_AMP_INGEST_ARN
else
  echo "$SERVICE_ACCOUNT_IAM_AMP_INGEST_ROLE_ARN IAM role for ingest already exists"
fi
echo $SERVICE_ACCOUNT_IAM_AMP_INGEST_ROLE_ARN

read -r -d '' service_account_config <<EOF
apiVersion: v1
kind: ServiceAccount
metadata:
  name: amp-iamproxy-ingest-service-account
  namespace: kube-system
  annotations:
    eks.amazonaws.com/role-arn: ${SERVICE_ACCOUNT_IAM_AMP_INGEST_ROLE_ARN}
EOF
echo "${service_account_config}" > sa.yaml
kubectl apply -f sa.yaml

helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
kubectl create ns prometheus || echo "Namespace exists"

aws_region=$(aws --profile ${infrastructure_profile} configure get region | xargs)

echo "Checking helm deployment status"
res=$(helm ls -n prometheus | grep prometheus-amp)
echo "Response from helm ls ${res}"
if test -z "$res"
then
  helm install prometheus-amp --namespace prometheus -f amp.yaml \
  --set serviceAccounts.server.annotations."eks\.amazonaws\.com/role-arn"="${IAM_PROXY_PROMETHEUS_ROLE_ARN}" \
  --set server.remoteWrite[0].url="https://aps-workspaces.${aws_region}.amazonaws.com/workspaces/${workspace_id}/api/v1/remote_write" \
  --set server.remoteWrite[0].sigv4.region=${aws_region} prometheus-community/prometheus
else
  echo "Prometheus Deployment found. Hence upgrading"
  helm upgrade --history-max 0 prometheus-amp --namespace prometheus -f amp.yaml \
  --set serviceAccounts.server.annotations."eks\.amazonaws\.com/role-arn"="${IAM_PROXY_PROMETHEUS_ROLE_ARN}" \
  --set server.remoteWrite[0].url="https://aps-workspaces.${aws_region}.amazonaws.com/workspaces/${workspace_id}/api/v1/remote_write" \
  --set server.remoteWrite[0].sigv4.region=${aws_region} prometheus-community/prometheus
fi
