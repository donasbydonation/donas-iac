#!/bin/bash

set -e

# - Env
ROOT_DIR=${ROOT_DIR?"ERROR: Required environment variable not set"}
source $ROOT_DIR/.env.config
source $ROOT_DIR/.env.credentials

# - Config
SH_OUT="$ROOT_DIR/aws_asg_user_data.autogen.sh"
WORKING_DIR='/etc/donas'

# - Dependency
$ROOT_DIR/.helpers.donas.me/docker/docker-compose/export.sh

# - Generate
cat << EOF > $SH_OUT
#!/bin/bash

# THIS .sh FILE IS AUTOGENERATED AT TIME: $(date)
# THIS FILE SHOULD NOT BE CHANGED MANUALLY AND
# SHOULD IGNORED BY '.gitignore'

EOF

# - Create dir
cat << EOF >> $SH_OUT
# - Begin
mkdir -pv $WORKING_DIR
mkdir -pv $WORKING_DIR/install

EOF

# - Install docker
cat << EOF >> $SH_OUT
# - Install Docker
curl -fsSL https://get.docker.com > $WORKING_DIR/install/docker.sh
chmod +x $WORKING_DIR/install/docker.sh
$WORKING_DIR/install/docker.sh

EOF

# - Install AWS CodeDeploy
cat << EOF >> $SH_OUT
# - Install AWS CodeDeploy agent
apt-get update -qq > /dev/null
DEBIAN_FRONTEND=noninteractive apt-get install -y -qq ruby-full > /dev/null
curl -fsSL https://aws-codedeploy-ap-northeast-2.s3.amazonaws.com/latest/install > $WORKING_DIR/install/codedeploy.sh
chmod +x $WORKING_DIR/install/codedeploy.sh
$WORKING_DIR/install/codedeploy.sh auto > /tmp/logfile
systemctl enable --now codedeploy-agent.service

EOF

# - Save 'docker-compose.yaml'
cat << EOF >> $SH_OUT
# - Save 'docker-compose.yaml'
cat << EOF > $WORKING_DIR/docker-compose.yaml
EOF
cat $ROOT_DIR/docker-compose.autogen.yaml >> $SH_OUT
echo 'EOF' >> $SH_OUT
echo >> $SH_OUT

# - Save 'application_stop.sh'
cat << EOF >> $SH_OUT
# - Save 'application_stop.sh'
cat << EOF > $WORKING_DIR/application_stop.sh
#!/bin/bash
docker compose -f $WORKING_DIR/docker-compose.yaml stop
docker compose -f $WORKING_DIR/docker-compose.yaml rm --force
EOF
echo 'EOF' >> $SH_OUT
cat << EOF >> $SH_OUT
chmod +x $WORKING_DIR/application_stop.sh

EOF

# - Save 'before_install.sh'
cat << EOF >> $SH_OUT
# - Save 'before_install.sh'
cat << EOF > $WORKING_DIR/before_install.sh
#!/bin/bash
docker compose -f $WORKING_DIR/docker-compose.yaml pull
EOF
echo 'EOF' >> $SH_OUT
cat << EOF >> $SH_OUT
chmod +x $WORKING_DIR/before_install.sh

EOF

# - Save 'application_start.sh'
cat << EOF >> $SH_OUT
# - Save 'application_start.sh'
cat << EOF > $WORKING_DIR/application_start.sh
#!/bin/bash
docker compose -f $WORKING_DIR/docker-compose.yaml up -d
EOF
echo 'EOF' >> $SH_OUT
cat << EOF >> $SH_OUT
chmod +x $WORKING_DIR/application_start.sh

EOF

# - Start server
cat << EOF >> $SH_OUT
# - Start server
$WORKING_DIR/application_start.sh
EOF

# - Print
base64 $SH_OUT
