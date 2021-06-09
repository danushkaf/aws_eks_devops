#!/bin/bash
GIT_COMMIT=$1
acc_id=$2
service_name=$3
infrastructure_profile=$4
env_prefix_value=$5
region=$(aws --profile ${infrastructure_profile} configure get region)
ecr_repoName="${acc_id}.dkr.ecr.${region}.amazonaws.com/${env_prefix_value}-${service_name}"

docker build -f ../../../../DockerFile -t ${ecr_repoName}:0.1.${GIT_COMMIT} ../../../../
docker tag ${ecr_repoName}:0.1.${GIT_COMMIT} ${ecr_repoName}:latest
