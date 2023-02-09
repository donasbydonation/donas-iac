# Donas GitOps config

## Provisioning scope

- AWS resources

## Resources that are NOT provisioned by this repository

- None

## Required environment variables

> Note: these variables MUST BE included to repository secret to be able to run GitHub actions successfully.

### Terraform

| Name | Description |
| --- | --- |
| `AWS_ACCESS_KEY_ID` | AWS access key id for terraforming |
| `AWS_SECRET_ACCESS_KEY` | AWS secret access key for terraforming |
| `AWS_ASG_USER_DATA` | `user_data` for launch template (AWS Auto Scaling Group) |
| `AWS_RDS_DBNAME` | AWS RDS database name to create |
| `AWS_RDS_PORT` | AWS RDS port |
| `AWS_RDS_USERNAME` | AWS RDS username |
| `AWS_RDS_PASSWORD` | AWS RDS password |

### Helpers

- Include every required environment variables for terraforming, and

| Name | Description |
| --- | --- |
| `GH_TOKEN` | GitHub token to access private repositories |
