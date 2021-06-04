#!/bin/bash

# create backup directory
mkdir /tmp/scc_backup

# create app folders if missing ( to support next cp )
# by design scc - is a persistent mounted volume
# it is supposed that it will have config already
mkdir -p /opt/sap/scc/{config,config_master,scc_config}

# backup config
cp -R /opt/sap/scc/{config,config_master,scc_config} /tmp/scc_backup

# update app from distributive (replace runtime files)
cp -R /tmp/scc_dist/* /opt/sap/scc

#restore config from backup
cp -R /tmp/scc_backup/* /opt/sap/scc

# clean temp files
rm -rf /tmp/scc_backup

# run the app
bash ./useFileUserStore.sh
bash ./go.sh