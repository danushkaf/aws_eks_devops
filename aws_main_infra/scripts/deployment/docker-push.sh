#!/bin/bash
GIT_COMMIT=$1
acc_id=$2
service_name=$3
infrastructure_profile=$4
env_prefix_value=$5
region=$(aws --profile ${infrastructure_profile} configure get region)
ecr_repoName="${acc_id}.dkr.ecr.${region}.amazonaws.com/${env_prefix_value}-${service_name}"

set +x
$(aws --profile ${infrastructure_profile} ecr get-login --no-include-email)
set -x
aws --profile ${infrastructure_profile} ecr create-repository --repository-name $env_prefix_value-$service_name --image-scanning-configuration scanOnPush=true || echo "repo exists"
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
aws --profile ${infrastructure_profile} ecr put-lifecycle-policy --repository-name $env_prefix_value-$service_name  --lifecycle-policy-text "file://ecr_rule.json" || echo "rule exists"
aws --profile ${infrastructure_profile} ecr batch-delete-image --repository-name ${env_prefix_value}-${service_name} --image-ids imageTag=0.1.${GIT_COMMIT} || echo "image tag doesnt exist"
aws --profile ${infrastructure_profile} ecr batch-delete-image --repository-name ${env_prefix_value}-${service_name} --image-ids imageTag=latest || echo "latest tag doesnt exist"
echo "Build number is 0.1.${GIT_COMMIT}"
docker push ${ecr_repoName}:latest
docker push ${ecr_repoName}:0.1.${GIT_COMMIT}
docker image rm ${ecr_repoName}:latest
docker image rm ${ecr_repoName}:0.1.${GIT_COMMIT}
