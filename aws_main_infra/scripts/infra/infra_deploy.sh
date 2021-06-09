#!/bin/bash
region=$1
stack_name=$2
node_group_stack_name=$3
eks_name=$4
domain=$5
environment_name=$6
min_nodes=$7
max_nodes=$8
ecr_repo=$9
shared_stack_name=${10}
infrastructure_account_id=${11}
infrastructure_profile=${12}
shared_account_id=${13}
shared_profile=${14}
env_prefix=${15}
dns_prefix=""
if test -z "${16}"
then
  echo "dns_prefix is empty."
else
  dns_prefix=${16}-
fi

# Push required images to deployment account
$(aws --profile ${shared_profile} ecr get-login --no-include-email)
docker pull ${shared_account_id}.dkr.ecr.${region}.amazonaws.com/apigw-ingress-controller:latest
docker tag ${shared_account_id}.dkr.ecr.${region}.amazonaws.com/apigw-ingress-controller:latest ${infrastructure_account_id}.dkr.ecr.${region}.amazonaws.com/apigw-ingress-controller:latest
aws --profile ${infrastructure_profile} ecr create-repository --repository-name apigw-ingress-controller --image-scanning-configuration scanOnPush=true || echo "repo exists"
cat << EOF > ecr_rule.json
{
   "rules": [
       {
           "rulePriority": 1,
           "description": "Expire images older than 20 images",
           "selection": {
               "tagStatus": "any",
               "countType": "imageCountMoreThan",
               "countNumber": 20
           },
           "action": {
               "type": "expire"
           }
       }
   ]
}
EOF
aws --profile ${infrastructure_profile} ecr put-lifecycle-policy --repository-name apigw-ingress-controller  --lifecycle-policy-text "file://ecr_rule.json" || echo "rule exists"
$(aws --profile ${infrastructure_profile} ecr get-login --no-include-email)
docker push ${infrastructure_account_id}.dkr.ecr.${region}.amazonaws.com/apigw-ingress-controller:latest

docker pull ${shared_account_id}.dkr.ecr.${region}.amazonaws.com/clamav:latest
docker tag ${shared_account_id}.dkr.ecr.${region}.amazonaws.com/clamav:latest ${infrastructure_account_id}.dkr.ecr.${region}.amazonaws.com/clamav:latest
aws --profile ${infrastructure_profile} ecr create-repository --repository-name clamav --image-scanning-configuration scanOnPush=true || echo "repo exists"
cat << EOF > ecr_rule.json
{
   "rules": [
       {
           "rulePriority": 1,
           "description": "Expire images older than 5 images",
           "selection": {
               "tagStatus": "any",
               "countType": "imageCountMoreThan",
               "countNumber": 5
           },
           "action": {
               "type": "expire"
           }
       }
   ]
}
EOF
aws --profile ${infrastructure_profile} ecr put-lifecycle-policy --repository-name clamav  --lifecycle-policy-text "file://ecr_rule.json" || echo "rule exists"
$(aws --profile ${infrastructure_profile} ecr get-login --no-include-email)
docker push ${infrastructure_account_id}.dkr.ecr.${region}.amazonaws.com/clamav:latest

aws --profile ${infrastructure_profile} sts get-caller-identity

aws --profile ${infrastructure_profile} s3api create-bucket --acl private --bucket ${env_prefix}-xyz-ingress-cf-s3-bucket --region ${region} --create-bucket-configuration LocationConstraint=${region} || echo "Bucket exists"
aws --profile ${infrastructure_profile} s3api put-bucket-encryption --bucket ${env_prefix}-xyz-ingress-cf-s3-bucket --server-side-encryption-configuration '{"Rules": [{"ApplyServerSideEncryptionByDefault": {"SSEAlgorithm": "AES256"}}]}' | echo "bucket encryption settings exists."
aws --profile ${infrastructure_profile} s3api put-public-access-block --bucket ${env_prefix}-xyz-ingress-cf-s3-bucket --public-access-block-configuration "BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true" | echo "bucket public settings exists."
cat << EOF > bucket-policy.json
{
    "Statement":[
        {
            "Action": "s3:*",
            "Effect":"Deny",
            "Principal": "*",
            "Resource":"arn:aws:s3:::${env_prefix}-xyz-ingress-cf-s3-bucket/*",
            "Condition":{
                "Bool":
                { "aws:SecureTransport": false }
            }
        }
    ]
}
EOF
aws --profile ${infrastructure_profile} s3api put-bucket-policy --bucket ${env_prefix}-xyz-ingress-cf-s3-bucket --policy file://bucket-policy.json | echo "policy exists"

log_role_arn=$(aws --profile ${shared_profile} cloudformation describe-stacks --region ${region} --stack-name ${shared_stack_name} --query "Stacks[0].Outputs[?OutputKey=='CWLogsAccessRoleArn'].OutputValue" --output text)

cert_arn=""
current_certs=$(aws --profile ${infrastructure_profile} acm list-certificates)

for k in $(jq '.CertificateSummaryList | keys | .[]' <<< "$current_certs"); do
  cert=$(jq -r ".CertificateSummaryList[$k]" <<< "$current_certs")
  domain_name=$(jq -r '.DomainName' <<< "$cert")
  if [[ "$domain_name" == "$domain" ]]; then
    cert_arn=$(jq -r '.CertificateArn' <<< "$cert")
    break
  fi
done

aws --profile ${infrastructure_profile} eks --region ${region} update-kubeconfig --name ${eks_name}
EKS_VPC_ID=$(aws --profile ${infrastructure_profile} cloudformation describe-stacks --region ${region} --stack-name ${infrastructure_profile}-${stack_name} --query "Stacks[0].Outputs[?OutputKey=='VpcId'].OutputValue" --output text)
EKS_NODE_GROUP=$(aws --profile ${infrastructure_profile} cloudformation describe-stacks --region ${region} --stack-name ${infrastructure_profile}-${node_group_stack_name} --query "Stacks[0].Outputs[?OutputKey=='NodeGroup'].OutputValue" --output text)
if [[ ${stack_name} == ${infrastructure_profile}-* ]] ;
then
  EKS_VPC_ID=$(aws --profile ${infrastructure_profile} cloudformation describe-stacks --region ${region} --stack-name ${stack_name} --query "Stacks[0].Outputs[?OutputKey=='VpcId'].OutputValue" --output text)
  EKS_NODE_GROUP=$(aws --profile ${infrastructure_profile} cloudformation describe-stacks --region ${region} --stack-name ${node_group_stack_name} --query "Stacks[0].Outputs[?OutputKey=='NodeGroup'].OutputValue" --output text)
fi
EKS_VPC_ID=$(echo $EKS_VPC_ID | tr -d ' ')
EKS_NODE_GROUP=$(echo $EKS_NODE_GROUP | tr -d ' ')

res=$(helm ls | grep infrastructure)
res_alb_ingress=$(helm ls -n kube-system | grep alb-ingress-controller)
res_apigw_ingress=$(helm ls | grep apigateway)
#res_isitio_init=$(helm ls istio-init)
#res_istio=$(helm ls istio)

kubectl get serviceaccount aws-lb-controller -n kube-system || ./aws-lb-controller.sh ${infrastructure_account_id} ${infrastructure_profile} ${eks_name}


if test -z "$res_alb_ingress"
then
  helm repo add eks https://aws.github.io/eks-charts
  kubectl apply -k "github.com/aws/eks-charts/stable/aws-load-balancer-controller//crds?ref=master"
  helm install alb-ingress-controller eks/aws-load-balancer-controller -n kube-system --set autoDiscoverAwsRegion=true --set autoDiscoverAwsVpcID=true --set clusterName=${eks_name} --set serviceAccount.create=false --set serviceAccount.name=aws-lb-controller
  sleep 10s
else
  helm upgrade --history-max 0 alb-ingress-controller eks/aws-load-balancer-controller -n kube-system --set autoDiscoverAwsRegion=true --set autoDiscoverAwsVpcID=true --set clusterName=${eks_name} --set serviceAccount.create=false --set serviceAccount.name=aws-lb-controller
  sleep 10s
fi

apigw_repo="${ecr_repo}/apigw-ingress-controller"

if test -z "$res_apigw_ingress"
then
  helm install apigateway ../../../helm_charts/aws_apigw_ingress_controller --set image.repository=$apigw_repo
  sleep 10s
else
  helm upgrade --history-max 0 apigateway ../../../helm_charts/aws_apigw_ingress_controller --set image.repository=$apigw_repo
  sleep 10s
fi

sleep 10s

#if test -z "$res_isitio_init"
#then
#  helm install ../../../helm_charts/Istio/istio-init --name istio-init --namespace istio-system
#  sleep 10s
#else
#  helm upgrade istio-init ../../../helm_charts/Istio/istio-init --namespace istio-system
#  sleep 10s
#fi
#
#
#
#if test -z "$res_istio"
#then
#  helm install ../../../helm_charts/Istio/istio --name istio --set global.mtls.auto=true --set global.mtls.enabled=false --set global.configValidation=false --set sidecarInjectorWebhook.enabled=true --set grafana.enabled=false --set servicegraph.enabled=true --set gateways.istio-ingressgateway.enabled=false --namespace istio-system
#  namespacelist=`cat ../../../helm_charts/deployment/namespaces/${environment_name}.txt`
#  export IFS=","
#  for word in $namespacelist; do
#    namespace="${word}"
#    echo ${namespace}
#    kubectl label namespace ${namespace} istio-injection=enabled
#  done
#else
#  helm upgrade istio ../../../helm_charts/Istio/istio --set global.mtls.auto=true --set global.mtls.enabled=false --set global.configValidation=false --set sidecarInjectorWebhook.enabled=true --set grafana.enabled=false --set servicegraph.enabled=true --set gateways.istio-ingressgateway.enabled=false --namespace istio-system
#  namespacelist=`cat ../../../helm_charts/deployment/namespaces/${environment_name}.txt`
#  export IFS=","
#  for word in $namespacelist; do
#    namespace="${word}"
#    echo ${namespace}
#    kubectl label namespace ${namespace} istio-injection=enabled
#  done
#sleep 10s
#fi
#
#sleep 10s

kubectl create ns clamav || echo "Namespace exists"

if test -z "$res"
then
  helm install infrastructure ../../../helm_charts/infrastructure --set logRoleARN=${log_role_arn},clusterName=${eks_name},certArn=${cert_arn},dnsNamePrefix=${dns_prefix},autoscalingGroup=${EKS_NODE_GROUP},scaleMin=${min_nodes},scaleMax=${max_nodes},hostedZone=${domain},region=${region},vpcID=${EKS_VPC_ID},environmentName=${environment_name},clamAVRepo=${infrastructure_account_id}.dkr.ecr.${region}.amazonaws.com/clamav
else
  helm upgrade --history-max 0 infrastructure ../../../helm_charts/infrastructure --set logRoleARN=${log_role_arn},clusterName=${eks_name},certArn=${cert_arn},dnsNamePrefix=${dns_prefix},autoscalingGroup=${EKS_NODE_GROUP},scaleMin=${min_nodes},scaleMax=${max_nodes},hostedZone=${domain},region=${region},vpcID=${EKS_VPC_ID},environmentName=${environment_name},clamAVRepo=${infrastructure_account_id}.dkr.ecr.${region}.amazonaws.com/clamav
fi

curl -o aws-k8s-cni.yaml https://raw.githubusercontent.com/aws/amazon-vpc-cni-k8s/release-1.7/config/v1.7/aws-k8s-cni.yaml
sed -i.bak -e "s/us-west-2/${region}/" aws-k8s-cni.yaml
kubectl apply -f aws-k8s-cni.yaml
