### Payment Service CF Templates

The Payment service has multiple separate CF Templates.
You can merge these into one big CF template using an npm module called `cfpack`
Link for CFPack is [here](https://github.com/eugene-manuilov/cfpack#getting-started)

When doing deployments it makes sense to have one huge CF template.
But when creating CF for different resources and for maintainability purpose, you can have smaller separate templates. Smaller CF templates make it easy to understand and also to test. You don't need to wait for long times when deleting a stack or creating one.

CFPack needs a configuration file which can be created by command `cfpack init`
This will create a file named `cfpack.config.js` in current directory.
Ensure to set correct value for `entry` in this template. For example, the config file here has entry pointing to current directory.

You can change `entry` to point to a directory which has multiple CF templates that you want to combine.
To merge all the CF templates into one, run the command `cfpack build`
That will output a combined JSON.
The JSON can be directly used for running the stack.
If you need a YAML output, then JSON CF can be converted to YAML using a npm module called YAMLJS.
YAMLJS can be found [here](https://www.npmjs.com/package/yamljs)

You can use the `json2yaml` command provided by YAMLJS.
Note that this is optional - as you can always run JSON CF template output by `cfpack`

#### Lambda deployment via CF

1. Note that you need to create a zip file.
2. The zip file should have a `index.js` at root level in zip file. It should not be nested inside a dir inside zip file
3. Upload the zip file to the s3 bucket names `xyz-lambda-packages`
4. The s3 bucket should already be present and should have the lambda packages. This can probably be automated via CI/CD pipeline.
5. Note that `secretsKmsKeysAndLambdas.cfn.yml` has the CloudFormation for AWS secrets for payment service and the required lambda functions definition. 