#!/bin/bash
shared_account_id=$1
shared_profile=$2
aws_region=$3

chmod +x ./infra_aws_config.sh
. ./infra_aws_config.sh ${shared_account_id} ${shared_profile} ${aws_region}

aws --profile ${shared_profile} s3api create-bucket --bucket lambda-code-for-xyz-logs --region=${aws_region} --create-bucket-configuration LocationConstraint=${aws_region} || echo "Bucket exists"
aws --profile ${shared_profile} s3api put-bucket-encryption --bucket lambda-code-for-xyz-logs --server-side-encryption-configuration '{"Rules": [{"ApplyServerSideEncryptionByDefault": {"SSEAlgorithm": "AES256"}}]}' | echo "bucket encryption settings exists."
cat << EOF > bucket-policy.json
{
    "Statement":[
        {
            "Action": "s3:*",
            "Effect":"Deny",
            "Principal": "*",
            "Resource":"arn:aws:s3:::lambda-code-for-xyz-logs/*",
            "Condition":{
                "Bool":
                { "aws:SecureTransport": false }
            }
        }
    ]
}
EOF
aws --profile ${shared_profile} s3api put-bucket-policy --bucket lambda-code-for-xyz-logs --policy file://bucket-policy.json | echo "policy exists"

sleep 5s

current_location=$(pwd)
cd $(pwd)/../../cf_templates/stacker/templates/elasticsearch/LogsToES
zip -r logs_to_es.zip index.js
aws --profile ${shared_profile} s3 cp logs_to_es.zip s3://lambda-code-for-xyz-logs/logs_to_es.zip --region=${aws_region}
cd ${current_location}

cd $(pwd)/../../cf_templates/stacker/templates/elasticsearch/Rollover
zip -r rollover.zip index.js
aws --profile ${shared_profile} s3 cp rollover.zip s3://lambda-code-for-xyz-logs/rollover.zip --region=${aws_region}
cd ${current_location}

cd $(pwd)/../../cf_templates/stacker/templates/elasticsearch/Delete_Old_Logs
zip -r delete_old_logs.zip index.js
aws --profile ${shared_profile} s3 cp delete_old_logs.zip s3://lambda-code-for-xyz-logs/delete_old_logs.zip --region=${aws_region}
cd ${current_location}

cd $(pwd)/../../cf_templates/stacker/templates/elasticsearch/Snapshot
zip -r snapshot.zip index.js
aws --profile ${shared_profile} s3 cp snapshot.zip s3://lambda-code-for-xyz-logs/snapshot.zip --region=${aws_region}
cd ${current_location}

cd $(pwd)/../../cf_templates/stacker/templates/elasticsearch/Snapshot-Register
zip -r snapshot_register.zip index.js
aws --profile ${shared_profile} s3 cp snapshot_register.zip s3://lambda-code-for-xyz-logs/snapshot_register.zip --region=${aws_region}
cd ${current_location}

aws --profile ${shared_profile} s3api create-bucket --bucket stacker.elasticsearch.cftemplates.xyz --region=${aws_region} --create-bucket-configuration LocationConstraint=${aws_region} || echo "Bucket exists"
aws --profile ${shared_profile} s3api put-bucket-encryption --bucket stacker.elasticsearch.cftemplates.xyz --server-side-encryption-configuration '{"Rules": [{"ApplyServerSideEncryptionByDefault": {"SSEAlgorithm": "AES256"}}]}' | echo "bucket encryption settings exists."
cat << EOF > bucket-policy.json
{
    "Statement":[
        {
            "Action": "s3:*",
            "Effect":"Deny",
            "Principal": "*",
            "Resource":"arn:aws:s3:::stacker.elasticsearch.cftemplates.xyz/*",
            "Condition":{
                "Bool":
                { "aws:SecureTransport": false }
            }
        }
    ]
}
EOF
aws --profile ${shared_profile} s3api put-bucket-policy --bucket stacker.elasticsearch.cftemplates.xyz --policy file://bucket-policy.json | echo "policy exists"

stacker build $(pwd)/../../cf_templates/stacker/conf/elasticsearch.env $(pwd)/../../cf_templates/stacker/elasticsearch-stacker.yaml -e template_path=$(pwd)/../../cf_templates/stacker --region=${aws_region}
