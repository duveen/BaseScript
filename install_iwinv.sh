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

## check
dnf update -y

dnf install -y epel-release
dnf install -y htop
dnf install -y langpacks-en
dnf groupinstall -y "Development Tools"
dnf install -y java-1.8.0-openjdk-devel git maven gradle

echo "export LANG=en_US.utf8" >> /etc/environment
echo "export JAVA_HOME=/etc/alternatives/java_sdk" >> /etc/environment

systemctl enable --now chronyd
chronyc tracking

firewall-cmd --permanent --zone=public --add-rich-rule='rule family="ipv4" source address="222.236.125.250" port protocol="tcp" port="1-65535" accept'
firewall-cmd --permanent --zone=public --add-rich-rule='rule family="ipv4" source address="222.236.125.250" port protocol="udp" port="1-65535" accept'
firewall-cmd --permanent --zone=public --add-rich-rule='rule family="ipv4" source address="10.5.0.0/16" port protocol="tcp" port="1-65535" accept'
firewall-cmd --permanent --zone=public --add-rich-rule='rule family="ipv4" source address="10.5.0.0/16" port protocol="udp" port="1-65535" accept'
firewall-cmd --permanent --zone=public --remove-service=ssh
firewall-cmd --permanent --zone=public --remove-service=cockpit

firewall-cmd --reload
