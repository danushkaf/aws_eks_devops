#!/bin/bash
aws_region=$1
bucket_name=$2
shared_profile=$3
os_db_username=$4
os_db_password=$5
os_system_admin_db_username=$6
os_system_admin_db_password=$7
os_runtime_admin_db_username=$8
os_runtime_admin_db_password=$9
os_runtime_log_admin_db_username=${10}
os_runtime_log_admin_db_password=${11}
os_session_admin_db_username=${12}
os_session_admin_db_password=${13}
os_platform_admin_db_password=${14}
os_service_password=${15}


aws --profile ${shared_profile} s3api create-bucket --acl=private --bucket=${bucket_name} --create-bucket-configuration=LocationConstraint=${aws_region} | echo "bucket exists."
aws --profile ${shared_profile} s3api put-bucket-encryption --bucket=${bucket_name} --server-side-encryption-configuration '{"Rules": [{"ApplyServerSideEncryptionByDefault": {"SSEAlgorithm": "AES256"}}]}' | echo "bucket encryption settings exists."
cat << EOF > bucket-policy.json
{
    "Statement":[
        {
            "Action": "s3:*",
            "Effect":"Deny",
            "Principal": "*",
            "Resource":"arn:aws:s3:::${bucket_name}/*",
            "Condition":{
                "Bool":
                { "aws:SecureTransport": false }
            }
        }
    ]
}
EOF
aws --profile ${shared_profile} s3api put-bucket-policy --bucket $bucket_name --policy file://bucket-policy.json | echo "policy exists"

stacker build $(pwd)/../../cf_templates/stacker/conf/shared.env $(pwd)/../../cf_templates/stacker/shared-stacker.yaml \
  -e template_path=$(pwd)/../../cf_templates/stacker \
  -e bucket_name=${bucket_name} \
  --region=${aws_region}

# stacker build $(pwd)/../../cf_templates/stacker/conf/shared.env $(pwd)/../../cf_templates/stacker/shared-os-lifetime-stacker.yaml \
#   -e template_path=$(pwd)/../../cf_templates/stacker \
#   -e os_db_username=${os_db_username} \
#   -e os_db_password=${os_db_password} \
#   -e os_system_admin_db_username=${os_system_admin_db_username} \
#   -e os_system_admin_db_password=${os_system_admin_db_password} \
#   -e os_runtime_admin_db_username=${os_runtime_admin_db_username} \
#   -e os_runtime_admin_db_password=${os_runtime_admin_db_password} \
#   -e os_runtime_log_admin_db_username=${os_runtime_log_admin_db_username} \
#   -e os_runtime_log_admin_db_password=${os_runtime_log_admin_db_password} \
#   -e os_session_admin_db_username=${os_session_admin_db_username} \
#   -e os_session_admin_db_password=${os_session_admin_db_password} \
#   -e os_platform_admin_db_password=${os_platform_admin_db_password} \
#   -e os_service_password=${os_service_password} \
#   -e bucket_name=${bucket_name} \
#   --region=${aws_region}
