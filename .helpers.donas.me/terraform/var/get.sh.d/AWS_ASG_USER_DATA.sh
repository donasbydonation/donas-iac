#!/bin/bash

cat << EOF | base64
#!/bin/bash

# - Begin
mkdir -pv /etc/donas
cd /etc/donas

# - Install Docker
curl -fsSL https://get.docker.com > install_docker.sh
chmod +x install_docker.sh
./install_docker.sh

# - Install AWS CodeDeploy agent
apt-get update -qq > /dev/null
DEBIAN_FRONTEND=noninteractive apt-get install -y -qq ruby-full > /dev/null
curl -fsSL https://aws-codedeploy-ap-northeast-2.s3.amazonaws.com/latest/install > install_codedeploy.sh
chmod +x install_codedeploy.sh
./install_codedeploy.sh auto > /tmp/logfile
systemctl enable --now codedeploy-agent.service
EOF
