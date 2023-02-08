#!/bin/bash

# - Begin
mkdir -pv /etc/donas
cd /etc/donas

# - Install Docker
FNAME=install.sh
curl -fsSL https://get.docker.com > $FNAME
chmod +x $FNAME
./$FNAME

# - Install AWS CodeDeploy agent
apt-get update -qq > /dev/null
DEBIAN_FRONTEND=noninteractive apt-get install -y -qq ruby-full > /dev/null
curl -fsSL https://aws-codedeploy-ap-northeast-2.s3.amazonaws.com/latest/install > $FNAME
chmod +x $FNAME
./$FNAME auto > /tmp/logfile
systemctl enable --now codedeploy-agent.service

# - Cleanup
rm -rf $FNAME

# - Start server
GH_TOKEN='{{GH_TOKEN}}'
GH_USER='donasbydonation'
GH_REPO='donas-iac'
GH_TARGET_REVISION='main'
curl -OH "Authorization: token $GH_TOKEN" https://raw.githubusercontent.com/$GH_USER/$GH_REPO/$GH_TARGET_REVISION/docker/docker-compose.yaml
docker compose up -d
