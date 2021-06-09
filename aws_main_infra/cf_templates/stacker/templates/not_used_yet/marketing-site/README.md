# Steps to Install CloudFront Distribution

1. Login to Deployment Account (eg: Dev). Go to ACM. Select region us-east-1. Create certificate for *.www.xyz.co (wildcard certificate).  You can do this simply by running the cloudformation template `cloudfront-certificate.yaml` in us-east-1 region in the Deployment account.  
Cloudformation will output the CNAME record to be added in the Route53 in CI/CD environment.  

2. Login to CICD Account. Go to Route53 and go to www.xyz.co hosted zone. Create a CNAME record set with details downloaded in previous step.  

3. Wait till cert goes in to validated state. Record the Arn of certificate.  

4. Then log in to Deployment Account and go to CloudFormation and switch to us-east-1 region and run cloudfront-waf.yaml. Record the Arn of WAF ACL from outputs of stack.  

5. Then switch to London region and run cloudfront.yaml.  

6. Now get the CloudFront domain name and go to CICD Account's Route53 hosted zone for www.xyz.co and create an Alias type record set. This is another record that needs to be created.
