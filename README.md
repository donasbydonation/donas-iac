# Donas GitOps config

## Provisioning scope

- AWS resources

## Resources that are NOT provisioned by this repository

- None

## Required environment variables

### Donas app

#### Admin console

```bash
APP_ADM_CONTAINER_PORT=''
APP_ADM_PORT=''
```

#### Web

```bash
APP_WEB_CONTAINER_PORT=''
APP_WEB_PORT=''
```

#### API server config

```bash
APP_API_CONTAINER_PORT=''
APP_API_PORT=''

APP_API_MAIL_HOST=''
APP_API_MAIL_PORT=''
APP_API_MAIL_USERNAME=''
APP_API_MAIL_PASSWORD=''

APP_API_JWT_SECRET_KEY=''
APP_API_JWT_EXPIRATION_MS=''
APP_API_ADMIN_EXPIRATION_MS=''

APP_API_AWS_ACCESS_KEY=''
APP_API_AWS_SECRET_KEY=''
APP_API_AWS_REGION=''
APP_API_AWS_S3_BUCKET=''

APP_API_ADMIN_USERNAME=''
APP_API_ADMIN_PASSWORD=''
```

### AWS

#### IAM

```bash
AWS_ACCESS_KEY_ID=''
AWS_SECRET_ACCESS_KEY=''
```

#### ASG

```bash
AWS_ASG_NAME=''
AWS_ASG_USER_DATA=''
```

#### CodeDeploy

```bash
AWS_CODEDEPLOY_APP_NAME=''
AWS_CODEDEPLOY_DEPLOY_GROUP_NAME=''
```

#### RDS

```bash
AWS_RDS_DBNAME=''
AWS_RDS_ENGINE=''
AWS_RDS_HOST=''
AWS_RDS_PASSWORD=''
AWS_RDS_PORT=''
AWS_RDS_USERNAME=''
```

### GitHub

```bash
GH_ACCESS_TOKEN=''
GH_OWNER=''
GH_REPO=''
```

### Docker

```bash
DOCKER_VERSION=''
```
