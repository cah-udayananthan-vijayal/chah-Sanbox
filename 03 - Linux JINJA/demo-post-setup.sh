#!/bin/bash
/SYSADM/tools/cah-mount.sh -device /dev/sdb -mount /data
/SYSADM/tools/domainjoin.sh
/SYSADM/tools/add-adgroups.sh -sudo ${AD_GROUP}

yum install -y java-1.8.0-openjdk
yum update -y