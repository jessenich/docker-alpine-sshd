#!/bin/sh

CROND_PARAMS=$@
if [ -z $CROND_CRONTAB ]; then
   echo "missing environment variable: CROND_CRONTAB"
   exit 1
fi

# set user group and home
set-user-group-home

# chown path
chown-path

# configure and exec cron deamon
crontab -u $EUSER $CROND_CRONTAB





 $CROND_PARAMS