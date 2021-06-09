#!/bin/bash

primary_account_id=$1
shared_account_id=$2
domain_name=$3
env_name=$4
aws_region=$5
infrastructure_profile=$6
shared_profile=$7
dns_prefix=$8
cert_exists=false
existing_cert_arn=""
dns_updated=false
cert_domain_name=""

if [ -n "${dns_prefix}" ]; then
  cert_domain_name="${dns_prefix}.${domain_name}"
else
  cert_domain_name="${domain_name}"
fi

creteDNSRecord() {
  cert_arn=$1
  region=$2
  hosted_zone_exists=false
  sleep 5s && cert_details=$(aws --profile ${infrastructure_profile} acm describe-certificate --certificate-arn $cert_arn --region $region)
  echo "Started managing route53 records in shared account"
  dns_record_name=$(echo $cert_details | jq '.Certificate.DomainValidationOptions[0].ResourceRecord.Name' | xargs)
  dns_record_type=$(echo $cert_details | jq '.Certificate.DomainValidationOptions[0].ResourceRecord.Type' | xargs)
  dns_record_value=$(echo $cert_details | jq '.Certificate.DomainValidationOptions[0].ResourceRecord.Value' | xargs)
  echo "Configured Shared Profile for aws cli"
  current_hosted_zones=$(aws --profile ${shared_profile} route53 list-hosted-zones)
  for k in $(jq '.HostedZones | keys | .[]' <<< "$current_hosted_zones"); do
    hosted_zone=$(jq -r ".HostedZones[$k]" <<< "$current_hosted_zones");
    hosted_zone_id=$(jq -r '.Id' <<< "$hosted_zone");
    hosted_zone_name=$(jq -r '.Name' <<< "$hosted_zone");
    echo "Hosted Zone Name is ${hosted_zone_name} and domain name is ${domain_name}"
    if [[ "${hosted_zone_name}" == "${domain_name}." ]]; then
      echo "Hostedzone found creating record sets"
      createCNAME $dns_record_name $dns_record_type $dns_record_value $hosted_zone_id
      hosted_zone_exists=true
      echo "Hosted zone exists after assignment : ${hosted_zone_exists}"
      break
    fi
  done
  echo "Hosted zone exists : ${hosted_zone_exists}"
  if [ $hosted_zone_exists = false ] ; then
    echo "Creatting Hosted Zone"
    timestamp=$(date +"%T")
    new_hosted_zone=$(aws --profile ${shared_profile} route53 create-hosted-zone --name $domain_name --caller-reference $timestamp)
    new_hosted_zone_id=$(echo $new_hosted_zone | jq '.HostedZone.Id' | xargs)
    createCNAME $dns_record_name $dns_record_type $dns_record_value $new_hosted_zone_id
  fi
}

createCNAME() {
  dns_record_name=$1
  dns_record_type=$2
  dns_record_value=$3
  hosted_zone_id=$4
  resource_record_set=$(aws --profile ${shared_profile} route53 list-resource-record-sets --hosted-zone-id $hosted_zone_id)
  record_set_exists=false
  for j in $(jq '.ResourceRecordSets | keys | .[]' <<< "$resource_record_set"); do
    record_set=$(jq -r ".ResourceRecordSets[$j]" <<< "$resource_record_set");
    record_set_name=$(jq -r '.Name' <<< "$record_set");
    if [[ "$record_set_name" == "$dns_record_name" ]]; then
      record_set_exists=true
      break
    fi
  done
  if [ "$record_set_exists" = true ]; then
    echo "Recordset already created."
  else
    echo "Recordset not created. Creating Recordset."
    cat > record_set_json.json <<EOF
{
  "Changes": [
    {
      "Action": "CREATE",
      "ResourceRecordSet": {
        "Name": "$dns_record_name",
        "Type": "$dns_record_type",
        "TTL": 300,
        "ResourceRecords": [
          {
            "Value": "$dns_record_value"
          }
        ]
      }
    }
  ]
}
EOF
    create_record_set_result=$(aws --profile ${shared_profile} route53 change-resource-record-sets --hosted-zone-id $hosted_zone_id --change-batch file://record_set_json.json)
    dns_updated=true
  fi
}

current_certs=$(aws --profile ${infrastructure_profile} acm list-certificates)

for k in $(jq '.CertificateSummaryList | keys | .[]' <<< "$current_certs"); do
  cert=$(jq -r ".CertificateSummaryList[$k]" <<< "$current_certs")
  domain=$(jq -r '.DomainName' <<< "$cert")
  if [[ "$domain" == "$cert_domain_name" ]]; then
    existing_cert_arn=$(jq -r '.CertificateArn' <<< "$cert")
    cert_exists=true
    break
  fi
done
if [ "$cert_exists" = true ]; then
  echo "Cert already created."
  creteDNSRecord $existing_cert_arn $aws_region
  echo $existing_cert_arn
else
  echo "Cert not created. Creating."
  new_cert=$(aws --profile ${infrastructure_profile} acm request-certificate --domain-name $cert_domain_name --validation-method DNS --subject-alternative-names *.$cert_domain_name)
  cert_arn=$(echo $new_cert | jq '.CertificateArn' | xargs)
  creteDNSRecord $cert_arn $aws_region
  echo $cert_arn
fi

# For cloudfornt distributions
if [[ "$aws_region" != "us-east-1" ]]; then
  current_certs=$(aws --profile ${infrastructure_profile} acm list-certificates --region us-east-1)
  cert_exists=false
  for k in $(jq '.CertificateSummaryList | keys | .[]' <<< "$current_certs"); do
    cert=$(jq -r ".CertificateSummaryList[$k]" <<< "$current_certs")
    domain=$(jq -r '.DomainName' <<< "$cert")
    if [[ "$domain" == "$cert_domain_name" ]]; then
      existing_cert_arn=$(jq -r '.CertificateArn' <<< "$cert")
      cert_exists=true
      break
    fi
  done
  if [ "$cert_exists" = true ]; then
    echo "Cert already created."
    creteDNSRecord $existing_cert_arn "us-east-1"
    echo $existing_cert_arn
  else
    echo "Cert not created. Creating."
    new_cert=$(aws --profile ${infrastructure_profile} acm request-certificate --domain-name $cert_domain_name --validation-method DNS --subject-alternative-names *.$cert_domain_name  --region us-east-1)
    cert_arn=$(echo $new_cert | jq '.CertificateArn' | xargs)
    creteDNSRecord $cert_arn "us-east-1"
    echo $cert_arn
  fi
fi

if $dns_updated ; then
  echo "Waiting for DNS to propagate"
  sleep 2000s
fi
