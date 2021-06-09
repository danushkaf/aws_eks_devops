#!/bin/bash
aws_profile=$1
enable_enhanced_security=$2
bucket_name=$3

aws_region=$(aws configure --profile ${aws_profile} get region)

if [ "${enable_enhanced_security}" == "true" ] ; then
  aws --profile ${aws_profile} s3api create-bucket --acl=private --bucket=${bucket_name} --create-bucket-configuration=LocationConstraint=${aws_region} | echo "bucket exists."
  aws --profile ${aws_profile} s3api put-bucket-encryption --bucket=${bucket_name} --server-side-encryption-configuration '{"Rules": [{"ApplyServerSideEncryptionByDefault": {"SSEAlgorithm": "AES256"}}]}' | echo "bucket encryption settings exists."
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
  aws --profile ${aws_profile} s3api put-bucket-policy --bucket ${bucket_name} --policy file://bucket-policy.json | echo "policy exists"

  stacker build $(pwd)/../../cf_templates/stacker/conf/enhanced_security_shared.env $(pwd)/../../cf_templates/stacker/shared-enhanced-security-stacker.yaml \
    -e template_path=$(pwd)/../../cf_templates/stacker \
    -e bucket_name=${bucket_name} \
    -e aws_profile=${aws_profile} \
    --region=${aws_region}
fi
