## Stacker cfn example

Read the following for configuration in stacker:
https://stacker.readthedocs.io/en/latest/config.html

In Stacker you can have both raw CF templates as well as python classes which will get converted to CF template ultimately.

Note: ensure to change the AWS profile first
Example:
`export AWS_PROFILE=master`

Command to build and deploy the stack
`stacker build conf/uat.env stacker.yaml --region=us-east-1`

`stacker build conf/uat.env stacker.yaml \
  -e main_infrastructure_stack_name=main-infrastructure-stack \
  -e infrastructure_profile=dev \
  -e shared_profile=shared \
  -e account_name=xxx \
  -e account_id=xxx \
  -e region=us-east-1 \
  -e db_username=xyz \
  -e db_password=xyz1234 \
  -e shared_stack_name=dev-shared-stackname \
  --region=us-east-1`


To destroy a submitted stack:
`stacker destroy conf/uat.env stacker.yaml --force --region=us-east-1`

Refer `stacker.yaml` which shows how to have interdependency between different stacks.
