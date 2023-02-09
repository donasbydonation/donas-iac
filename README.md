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
| `TF_VAR_AWS_ASG_USER_DATA` | `user_data` for launch template (AWS Auto Scaling Group) |
