#!/bin/bash
region=$1
stack_name=$2
eks_name=$3
infrastructure_profile=$4

aws --profile ${infrastructure_profile} sts get-caller-identity
EKS_INSTANCE_ROLE=$(aws --profile ${infrastructure_profile} cloudformation describe-stacks --region ${region} --stack-name ${infrastructure_profile}-${stack_name} --query "Stacks[0].Outputs[?OutputKey=='NodeInstanceRole'].OutputValue" --output text)
if [[ ${stack_name} == ${infrastructure_profile}-* ]] ;
then
  EKS_INSTANCE_ROLE=$(aws --profile ${infrastructure_profile} cloudformation describe-stacks --region ${region} --stack-name ${stack_name} --query "Stacks[0].Outputs[?OutputKey=='NodeInstanceRole'].OutputValue" --output text)
fi
cat << EOF > aws-auth-cm.yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: aws-auth
  namespace: kube-system
data:
  mapRoles: |
    - rolearn: ${EKS_INSTANCE_ROLE}
      username: system:node:{{EC2PrivateDNSName}}
      groups:
        - system:bootstrappers
        - system:nodes
EOF
aws --profile ${infrastructure_profile} eks --region ${region} update-kubeconfig --name ${eks_name}
kubectl apply -f aws-auth-cm.yaml
