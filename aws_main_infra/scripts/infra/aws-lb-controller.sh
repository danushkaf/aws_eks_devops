#!/bin/bash
infrastructure_account_id=$1
infrastructure_profile=$2
eks_name=$3

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
aws --profile ${infrastructure_profile} iam create-open-id-connect-provider --cli-input-json file://create-open-id-connect-provider.json

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
          "${OIDC_PROVIDER}:sub": "system:serviceaccount:kube-system:aws-lb-controller"
        }
      }
    }
  ]
}
EOF
echo "${TRUST_RELATIONSHIP}" > trust.json
ROLE_NAME=aws_lb_eks_service_role
aws --profile ${infrastructure_profile} iam create-role --role-name ${ROLE_NAME} --assume-role-policy-document file://trust.json --description "Service role for aws lb eks integration"
curl -o iam-policy.json https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/main/docs/install/iam_policy.json
policy_arn=$(aws --profile ${infrastructure_profile} iam create-policy --policy-name AWSLoadBalancerControllerIAMPolicy  --policy-document file://iam-policy.json | jq ".Policy.Arn" | xargs)
aws iam --profile ${infrastructure_profile} attach-role-policy --role-name ${ROLE_NAME} --policy-arn ${policy_arn}
read -r -d '' service_account_config <<EOF
apiVersion: v1
kind: ServiceAccount
metadata:
  name: aws-lb-controller
  namespace: kube-system
  annotations:
    eks.amazonaws.com/role-arn: arn:aws:iam::${infrastructure_account_id}:role/${ROLE_NAME}
EOF
echo "${service_account_config}" > sa.yaml
kubectl apply -f sa.yaml
