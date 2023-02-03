# Donas GitOps config

## Provisioning scope

- AWS resources

## Resources that are NOT provisioned by this repository

- Terraform tfstate backend
  - S3 bucket (`arn:aws:s3:::donas-tfstate-bucket`)
  - DynamoDB table (`arn:aws:dynamodb:ap-northeast-2:129435097667:table/donas-tfstate-lock`)
