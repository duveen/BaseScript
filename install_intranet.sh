#!/usr/bin/env bash

if [ "$(id -u)" != "0" ]; then
   echo "'$0' must be run as root" 1>&2
   exit 1
fi

MIRROR="ftp.yjsoft.xyz\/rocky-linux\/8.5"

REPO=/etc/yum.repos.d/Rocky-AppStream.repo
MOVE_REPOS="http:\/\/${MIRROR}\/AppStream\/x86_64\/os"
sed  -i.bak -re "s/^(mirrorlist(.*))/##\1/g" -re "s/[#]*baseurl(.*)/baseurl=${MOVE_REPOS}/" ${REPO} 

REPO=/etc/yum.repos.d/Rocky-BaseOS.repo
MOVE_REPOS="http:\/\/${MIRROR}\/BaseOS\/x86_64\/os"
sed  -i.bak -re "s/^(mirrorlist(.*))/##\1/g" -re "s/[#]*baseurl(.*)/baseurl=${MOVE_REPOS}/" ${REPO} 

REPO=/etc/yum.repos.d/Rocky-Extras.repo
MOVE_REPOS="http:\/\/${MIRROR}\/extras\/x86_64\/os"
sed  -i.bak -re "s/^(mirrorlist(.*))/##\1/g" -re "s/[#]*baseurl(.*)/baseurl=${MOVE_REPOS}/" ${REPO}

wget https://raw.githubusercontent.com/duveen/BaseScript/main/epel-yjsoft -O /etc/yum.repos.d/epel.repo
wget https://raw.githubusercontent.com/duveen/BaseScript/main/epel-modular-yjsoft -O /etc/yum.repos.d/epel-modular.repo
wget http://ftp.yjsoft.xyz/epel/RPM-GPG-KEY-EPEL-8 -O /etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-8

## check
dnf update -y

dnf install -y htop
dnf install -y langpacks-en
dnf groupinstall -y "Development Tools"
dnf install -y java-1.8.0-openjdk-devel git maven gradle

echo "export LANG=en_US.utf8" >> /etc/environment
echo "export JAVA_HOME=/etc/alternatives/java_sdk" >> /etc/environment

systemctl enable --now chronyd
chronyc tracking

systemctl disable --now firewalld
