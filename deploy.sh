#!/bin/bash
DATETIME=$(date +%Y%m%d-%H%M%S) 
PROJECT=sap-fin
SERVICE=sap-cloud-connector
git tag -a $PROJECT-$DATETIME -m "Rollout $DATETIME"
cat << EOF > .deploy
commit: $(git rev-parse HEAD)
tag: $PROJECT-$DATETIME
deployed-from: $(hostname)
deployed-by: $USER
deploy-date: $DATETIME
EOF
docker build --pull . -t docker.artifactory.booking.com/projects/$PROJECT/$SERVICE:$(git rev-parse HEAD)
