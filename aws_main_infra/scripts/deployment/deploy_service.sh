#!/bin/bash

service_name=$1
acc_id=$2
imageTag=$3
environment=$4
infrastructure_profile=$5
eks_name=$6
domain_name=$7
replica_count=$8
database_name=$9
route53_role_arn=${10}
envNamePrefix=${11}
domainNamePrefix=${12}

#eks_region="us-east-2"
certificate_arn=""
current_certs=$(aws --profile ${infrastructure_profile} acm list-certificates)

for k in $(jq '.CertificateSummaryList | keys | .[]' <<< "$current_certs"); do
  cert=$(jq -r ".CertificateSummaryList[$k]" <<< "$current_certs")
  domain=$(jq -r '.DomainName' <<< "$cert")
  if [[ "$domain" == "$domain_name" ]]; then
    certificate_arn=$(jq -r '.CertificateArn' <<< "$cert")
    break
  fi
done
echo "Certificate Arn is : ${certificate_arn}"

region=$(aws --profile ${infrastructure_profile} configure get region)
imageRepo="${acc_id}.dkr.ecr.${region}.amazonaws.com/${envNamePrefix}-${service_name}"

secretname="IL-DB-Password"
custom_domain="${domain_name}"
if [ -n "${envNamePrefix}" ]; then
  secretname="${envNamePrefix}-IL-DB-Password"
fi

if [ -n "${domainNamePrefix}" ]; then
  custom_domain="${domainNamePrefix}.${domain_name}"
fi

rm ~/.kube/config

secret=$(aws --profile ${infrastructure_profile} secretsmanager get-secret-value --secret-id $secretname)
secretstring=$(jq '.SecretString' <<< "$secret")
secretstring=${secretstring/"\"{"/"{"}
secretstring=${secretstring/"}\""/"}"}
secretstring=$(echo $secretstring | xargs)
secretstring=${secretstring//" "/","}
dbpassword=$(jq '.password' <<< "$secretstring" | xargs)
dbusername=$(jq '.username' <<< "$secretstring" | xargs)
dbpassword=$(printf $dbpassword | base64)
dbusername=$(printf $dbusername | base64)
dbhost=$(jq '.host' <<< "$secretstring" | xargs)
dbUrl="jdbc:mysql://${dbhost}:3306/"
dbname=$(jq '.dbname' <<< "$secretstring" | xargs)

echo "DB url is : ${dbUrl}"
echo "DB dbname is : ${dbname}"
echo "DB username is : '${dbusername}'"


echo "Copying the values.yaml file for environment: ${envNamePrefix}."
`cp ../../../../${service_name}/values_${envNamePrefix}.yaml ../../../../${service_name}/values.yaml`

hosted_zone="${domain_name}."

aws --profile ${infrastructure_profile} eks --region ${region} update-kubeconfig --name ${eks_name}

helmCommonUpgrade() {
  namespace=$1
  helm upgrade --history-max 0 xyz-${namespace}-common ../../../helm_charts/deployment/common/${environment}/common --set ingress.annotations.'apigateway\.ingress\.kubernetes\.io/certificate-arn'=${certificate_arn},ingress.annotations.'apigateway\.ingress\.kubernetes\.io/custom-domain-name'=${custom_domain},ingress.annotations.'apigateway\.ingress\.kubernetes\.io/hosted-zone-name'=${hosted_zone},ingress.annotations.'apigateway\.ingress\.kubernetes\.io/route53-assume-role-arn'=${route53_role_arn} --namespace ${namespace}
  # helm upgrade --history-max 0 xyz-${namespace}-common ../../../helm_charts/deployment/common/${environment}/common --namespace ${namespace}
}

helmCommonDeploy() {
  namespace=$1
  helm install xyz-${namespace}-common ../../../helm_charts/deployment/common/${environment}/common --set ingress.annotations.'apigateway\.ingress\.kubernetes\.io/certificate-arn'=${certificate_arn},ingress.annotations.'apigateway\.ingress\.kubernetes\.io/custom-domain-name'=${custom_domain},ingress.annotations.'apigateway\.ingress\.kubernetes\.io/hosted-zone-name'=${hosted_zone},ingress.annotations.'apigateway\.ingress\.kubernetes\.io/route53-assume-role-arn'=${route53_role_arn} --namespace ${namespace}
  # helm install xyz-${namespace}-common ../../../helm_charts/deployment/common/${environment}/common --namespace ${namespace}
}

helmDeploy() {
  namespace=$1
  dbUrl=$2
  helm install xyz-${namespace}-${service_name} ../../../../${service_name} --set databaseJDBCUrlPrefix=${dbUrl},databaseUserName=${dbusername},databasePassword=${dbpassword},databaseName=${dbname},deployments.replicaCount=${replica_count},deployments.image.repository=${imageRepo},deployments.image.tag=${imageTag},environmentPropertyValue=${environment} --namespace ${namespace}
  helmCommonUpgrade ${namespace}
}

namespacelist=`cat ../namespaces/${environment}.txt`
export IFS=","
for word in $namespacelist; do
  namespace="${word}"
  kubectl create ns ${namespace} || echo "Namespace exists"

  res=$(helm ls --all -n ${namespace} | grep xyz-${namespace}-common)
  echo $res
  if test -z "$res"
  then
    echo "Comon Deloyment not found hence deploying"
    helmCommonDeploy $namespace
  else
    status=$(helm ls --all -n ${namespace} | grep xyz-${namespace}-common | xargs | cut -d' ' -f8 | xargs)
    echo "Common deployment status is : ${status}"
    # if [[ "$status" != "DEPLOYED" ]]; then
    #   # echo "Deleting the existing failing common deployment."
    #   # helm del --purge ${namespace}-common
    #   # helmCommonDeploy $namespace
    # fi
  fi

  sleep 5s

  res=$(helm ls --all -n ${namespace} | grep xyz-${namespace}-${service_name})
  echo $res
  if test -z "$res"
  then
    echo "Service Deloyment not found hence deploying"
    helmDeploy $namespace $dbUrl
  else
    status=$(helm ls --all -n ${namespace} | grep xyz-${namespace}-${service_name} | xargs | cut -d' ' -f8 | xargs)
    echo "Status is : ${status}"
    if [[ "$status" != "deployed" ]]; then
      echo "Deleting the existing failing deployment."
      helm uninstall xyz-${namespace}-${service_name}
      sleep 5s
      helmDeploy $namespace $dbUrl
    else
      echo "Service Deloyment found hence upgrading"
      helm upgrade --history-max 0 xyz-${namespace}-${service_name} ../../../../${service_name} --set databaseJDBCUrlPrefix=${dbUrl},databaseUserName=${dbusername},databasePassword=${dbpassword},databaseName=${dbname},deployments.replicaCount=${replica_count},deployments.image.repository=${imageRepo},deployments.image.tag=${imageTag},environmentPropertyValue=${environment} --namespace ${namespace}
      sleep 5s
      echo "Service Deloyment found hence upgrading common"
      helmCommonUpgrade ${namespace}
    fi
  fi
done
