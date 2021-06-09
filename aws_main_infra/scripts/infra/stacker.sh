#!/bin/bash
environment_name=$1
primary_account_id=$2
primary_profile=$3
shared_account_id=$4
shared_profile=$5
db_username=$6
db_password=$7
aws_region=$8
mambu_username=$9
mambu_password=${10}
stacker_bucket=${11}
os_db_username=${12}
os_db_password=${13}
os_system_admin_db_username=${14}
os_system_admin_db_password=${15}
os_runtime_admin_db_username=${16}
os_runtime_admin_db_password=${17}
os_runtime_log_admin_db_username=${18}
os_runtime_log_admin_db_password=${19}
os_session_admin_db_username=${20}
os_session_admin_db_password=${21}
os_platform_admin_db_password=${22}
os_service_password=${23}
datalake_redshift_username=${24}
datalake_redshift_password=${25}
trunarrative_credential="${26}"
clearbank_credential="${27}"
clearbank_account=${28}
clearbank_pub_key="${29}"
domain_name=${30}
os_subdomain=${31}
almis_sftp_public_ssh_key="${32}"
access_sftp_public_ssh_key="${33}"
etl_mambu_username="${34}"
etl_mambu_password="${35}"
os_etl_admin_db_username=${36}
os_etl_admin_db_password=${37}
os_etl_ro_db_username=${38}
os_etl_ro_db_password=${39}
os_lifetime_system_admin_db_username=${40}
os_lifetime_system_admin_db_password=${41}
os_lifetime_runtime_admin_db_username=${42}
os_lifetime_runtime_admin_db_password=${43}
os_lifetime_runtime_log_admin_db_username=${44}
os_lifetime_runtime_log_admin_db_password=${45}
os_lifetime_session_admin_db_username=${46}
os_lifetime_session_admin_db_password=${47}
os_lifetime_platform_admin_db_password=${48}
os_lifetime_service_password=${49}
dns_prefix=${50}

existing_cert_arn=""
existing_os_cert_arn=""
existing_os_auth_cert_arn=""
existing_us_east_1_cert_arn=""
sub_domain_name=""
if [ -n "${dns_prefix}" ]; then
  sub_domain_name="${dns_prefix}.${os_subdomain}"
else
  sub_domain_name="${os_subdomain}"
fi

current_certs=$(aws --profile ${primary_profile} acm list-certificates)
for k in $(jq '.CertificateSummaryList | keys | .[]' <<< "$current_certs"); do
  cert=$(jq -r ".CertificateSummaryList[$k]" <<< "$current_certs")
  domain=$(jq -r '.DomainName' <<< "$cert")
  if [[ "$domain" == "$domain_name" ]]; then
    existing_cert_arn=$(jq -r '.CertificateArn' <<< "$cert")
  fi
  if [[ "$domain" == "$os_subdomain" ]]; then
    existing_os_cert_arn=$(jq -r '.CertificateArn' <<< "$cert")
  fi
done

if [[ "$aws_region" != "us-east-1" ]]; then
  current_certs=$(aws --profile ${primary_profile} acm list-certificates --region us-east-1)
  for k in $(jq '.CertificateSummaryList | keys | .[]' <<< "$current_certs"); do
    cert=$(jq -r ".CertificateSummaryList[$k]" <<< "$current_certs")
    domain=$(jq -r '.DomainName' <<< "$cert")
    if [[ "$domain" == "$domain_name" ]]; then
      existing_us_east_1_cert_arn=$(jq -r '.CertificateArn' <<< "$cert")
    fi
    if [[ "$domain" == "$sub_domain_name" ]]; then
      existing_os_auth_cert_arn=$(jq -r '.CertificateArn' <<< "$cert")
    fi
  done
else
  existing_us_east_1_cert_arn=$existing_cert_arn
  existing_os_auth_cert_arn=$existing_os_cert_arn
fi
echo "Certificate ARN is ${existing_cert_arn}"
echo "US EAST 1 Certificate ARN is ${existing_us_east_1_cert_arn}"
echo "OutSystems Certificate ARN is ${existing_os_cert_arn}"

stacker build $(pwd)/../../cf_templates/stacker/conf/${environment_name}.env $(pwd)/../../cf_templates/stacker/main-stacker.yaml \
  -e template_path=$(pwd)/../../cf_templates/stacker \
  -e db_username=${db_username} \
  -e db_password=${db_password} \
  -e mambu_username=${mambu_username} \
  -e mambu_password=${mambu_password} \
  -e cb_key=${cb_key} \
  -e cert_arn=${existing_cert_arn} \
  -e os_cert_arn=${existing_os_cert_arn} \
  -e os_auth_cert_arn=${existing_os_auth_cert_arn} \
  -e us_east_1_cert_arn=${existing_us_east_1_cert_arn} \
  -e cb_token=${cb_token} \
  -e os_db_username=${os_db_username} \
  -e os_db_password=${os_db_password} \
  -e os_system_admin_db_username=${os_system_admin_db_username} \
  -e os_system_admin_db_password=${os_system_admin_db_password} \
  -e os_runtime_admin_db_username=${os_runtime_admin_db_username} \
  -e os_runtime_admin_db_password=${os_runtime_admin_db_password} \
  -e os_runtime_log_admin_db_username=${os_runtime_log_admin_db_username} \
  -e os_runtime_log_admin_db_password=${os_runtime_log_admin_db_password} \
  -e os_session_admin_db_username=${os_session_admin_db_username} \
  -e os_session_admin_db_password=${os_session_admin_db_password} \
  -e os_platform_admin_db_password=${os_platform_admin_db_password} \
  -e os_service_password=${os_service_password} \
  -e datalake_redshift_username=${datalake_redshift_username} \
  -e datalake_redshift_password=${datalake_redshift_password} \
  -e trunarrative_credential="${trunarrative_credential}" \
  -e clearbank_credential="${clearbank_credential}" \
  -e clearbank_account=${clearbank_account} \
  -e clearbank_pub_key="${clearbank_pub_key}" \
  -e almis_sftp_public_ssh_key="${almis_sftp_public_ssh_key}" \
  -e access_sftp_public_ssh_key="${access_sftp_public_ssh_key}" \
  -e etl_mambu_username=${etl_mambu_username} \
  -e etl_mambu_password=${etl_mambu_password} \
  -e os_etl_admin_db_username=${os_etl_admin_db_username} \
  -e os_etl_admin_db_password=${os_etl_admin_db_password} \
  -e os_etl_ro_db_username=${os_etl_ro_db_username} \
  -e os_etl_ro_db_password=${os_etl_ro_db_password} \
  -e os_lifetime_system_admin_db_username=${os_lifetime_system_admin_db_username} \
  -e os_lifetime_system_admin_db_password=${os_lifetime_system_admin_db_password} \
  -e os_lifetime_runtime_admin_db_username=${os_lifetime_runtime_admin_db_username} \
  -e os_lifetime_runtime_admin_db_password=${os_lifetime_runtime_admin_db_password} \
  -e os_lifetime_runtime_log_admin_db_username=${os_lifetime_runtime_log_admin_db_username} \
  -e os_lifetime_runtime_log_admin_db_password=${os_lifetime_runtime_log_admin_db_password} \
  -e os_lifetime_session_admin_db_username=${os_lifetime_session_admin_db_username} \
  -e os_lifetime_session_admin_db_password=${os_lifetime_session_admin_db_password} \
  -e os_lifetime_platform_admin_db_password=${os_lifetime_platform_admin_db_password} \
  -e os_lifetime_service_password=${os_lifetime_service_password} \
  --region=${aws_region}
