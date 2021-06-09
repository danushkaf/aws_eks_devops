#!/bin/bash
env_prefix=$1
infrastructure_profile=$2

echo "creating asymmetric kms key for Clearbank"
createdKeyJson = $(aws --profile ${infrastructure_profile} kms create-key --key-usage "SIGN_VERIFY" --description "Public and private key for Clearbank communication" --customer-master-key-spec "RSA_2048")
sleep 4s
createdKmsKeyId=$(echo $createdKeyJson | jq '.KeyMetaData.KeyId' | xargs)
aws --profile ${infrastructure_profile} kms create-alias --alias-name $env_prefix"_ClearBank_Keys" --target-key-id $createdKmsKeyId
echo "Asymmetric Key for Clearbank created"
