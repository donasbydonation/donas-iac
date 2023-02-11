# Donas GitOps config

## Provisioning scope

- AWS resources

## Resources that are NOT provisioned by this repository

- None

## Required environment variables

### GitHub actions

> Note: these variables MUST BE included to repository secret to be able to run GitHub actions successfully.

| Name | Description |
| --- | --- |
| `APP_WEB_PORT` | Same w/ \[Docker.`APP_WEB_PORT`\] |
| `AWS_ACCESS_KEY_ID` | Same w/ \[Terraform.`AWS_ACCESS_KEY_ID`\] |
| `AWS_SECRET_ACCESS_KEY` | Same w/ \[Terraform.`AWS_SECRET_ACCESS_KEY`\] |
| `AWS_ASG_USER_DATA` | Same w/ \[Terraform.`TF_VAR_AWS_ASG_USER_DATA`\] |
| `AWS_RDS_DBNAME` | Same w/ \[Terraform.`TF_VAR_AWS_RDS_DBNAME`\] |
| `AWS_RDS_ENGINE` | Same w/ \[Terraform.`TF_VAR_AWS_RDS_ENGINE`\] |
| `AWS_RDS_PASSWORD` | Same w/ \[Terraform.`TF_VAR_AWS_RDS_PASSWORD`\] |
| `AWS_RDS_PORT` | Same w/ \[Terraform.`TF_VAR_AWS_RDS_PORT`\] |
| `AWS_RDS_USERNAME` | Same w/ \[Terraform.`TF_VAR_AWS_RDS_PASSWORD`\] |

### Terraform

| Name | Description |
| --- | --- |
| `AWS_ACCESS_KEY_ID` | AWS access key id for terraforming |
| `AWS_SECRET_ACCESS_KEY` | AWS secret access key for terraforming |
| `TF_VAR_APP_WEB_PORT` | Same w/ \[Docker.`APP_WEB_PORT`\] (AWS Security Group) |
| `TF_VAR_AWS_ASG_USER_DATA` | `user_data` for launch template (AWS Auto Scaling Group) |
| `TF_VAR_AWS_RDS_ENGINE` | AWS RDS engine type |
| `TF_VAR_AWS_RDS_DBNAME` | AWS RDS database name to create |
| `TF_VAR_AWS_RDS_PORT` | AWS RDS port |
| `TF_VAR_AWS_RDS_USERNAME` | AWS RDS username |
| `TF_VAR_AWS_RDS_PASSWORD` | AWS RDS password |

### Docker

| Name | Description |
| --- | --- |
| `APP_API_PORT` | Ingress port for `ghcr.io/donasbydonation/back-end` |
| `APP_WEB_PORT` | Ingress port for `ghcr.io/donasbydonation/front-end` |
| `AWS_RDS_DBNAME` | Same w/ \[Terraform.`TF_VAR_AWS_RDS_DBNAME`\] |
| `AWS_RDS_ENGINE` | Same w/ \[Terraform.`TF_VAR_AWS_RDS_ENGINE`\] |
| `AWS_RDS_HOST` | RDS hostname (known after terraform apply) |
| `AWS_RDS_PASSWORD` | Same w/ \[Terraform.`TF_VAR_AWS_RDS_PASSWORD`\] |
| `AWS_RDS_PORT` |Same w/ \[Terraform.`TF_VAR_AWS_RDS_PORT`\] |
| `AWS_RDS_USERNAME` |Same w/ \[Terraform.`TF_VAR_AWS_RDS_USERNAME`\] |

### Helpers

- Include every required environment variables for terraforming, and

| Name | Description |
| --- | --- |
| `GH_ACCESS_TOKEN` | GitHub token to access private repositories |
