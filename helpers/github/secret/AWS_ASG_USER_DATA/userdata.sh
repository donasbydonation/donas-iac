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

# - Setup files
## - 'docker-compose.yaml'
curl https://raw.githubusercontent.com/{{GH_OWNER}}/{{GH_REPO}}/{{GH_BRANCH}}/{{GH_PATH}}/docker-compose.yaml \
    -H "Authorization: token {{GH_ACCESS_TOKEN}}" \
    > docker-compose.yaml

## - 'docker-compose.env'
curl https://raw.githubusercontent.com/{{GH_OWNER}}/{{GH_REPO}}/{{GH_BRANCH}}/{{GH_PATH}}/docker-compose.b64 \
    -H "Authorization: token {{GH_ACCESS_TOKEN}}" \
    | base64 -d \
    > docker-compose.env
    
## - 'docker-compose.sh'
cat << EOF > docker-compose.sh
#!/bin/bash

docker compose --env-file docker-compose.env stop
docker compose --env-file docker-compose.env rm -f
curl https://raw.githubusercontent.com/{{GH_OWNER}}/{{GH_REPO}}/{{GH_BRANCH}}/{{GH_PATH}}/docker-compose.yaml \
    -H "Authorization: token {{GH_ACCESS_TOKEN}}" \
    > docker-compose.yaml
curl https://raw.githubusercontent.com/{{GH_OWNER}}/{{GH_REPO}}/{{GH_BRANCH}}/{{GH_PATH}}/docker-compose.b64 \
    -H "Authorization: token {{GH_ACCESS_TOKEN}}" \
    | base64 -d \
    > docker-compose.env
docker compose --env-file docker-compose.env pull
docker compose --env-file docker-compose.env up -d
EOF
chmod +x docker-compose.sh

# - Start server
./docker-compose.sh