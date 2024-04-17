#!/bin/bash

#Variables
FTP_HOST="192.168.15.80"
FTP_250_HOST="shares.fwut.xyz"
FTP_USER="devops"
FTP_250_USER="gitlab"
FTP_PASS='!QASD7d76d'
FTP_250_PASS='P@ssw0rd'

BACKUP_DIR="/data/git_backups/full_bkp"
if [ -d "$BACKUP_DIR" ]; then rm -Rf $BACKUP_DIR; fi

mkdir /data/git_backups/full_bkp
mkdir /data/git_backups/full_bkp/data
mkdir /data/git_backups/full_bkp/config

#Data backup
docker exec -ti gitlab-ce gitlab-backup create 
mv /data/gitlab/var/opt/gitlab/backups/* /data/git_backups/full_bkp/data

#Configuration backup 
docker exec -ti gitlab-ce gitlab-ctl backup-etc 
mv /data/gitlab/etc/gitlab/config_backup/* /data/git_backups/full_bkp/config

tar -zcf /data/git_backups/backup_$(date +%d%m%Y).tar.gz -C /data/git_backups/full_bkp/

backup_name=`ls -t /data/git_backups/ | head -n1`

#wput -u -B -q --basename=/data/git_backups/ /data/git_backups/$backup_name ftp://$FTP_USER:$FTP_PASS@$FTP_HOST/Sync/Gitlab/
#wput -u -B -q -R --basename=/data/git_backups/ /data/git_backups/$backup_name ftp://$FTP_250_USER:$FTP_250_PASS@$FTP_250_HOST/mnt/lun01/Backup-01/gitlab/
