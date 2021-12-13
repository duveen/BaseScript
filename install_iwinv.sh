#!/usr/bin/env bash

BASE_REPOS=/etc/yum.repos.d/CentOS-Linux-BaseOS.repo

KAKAO="mirror.kakao.com\/centos"

if [ "$(id -u)" != "0" ]; then
   echo "'$0' must be run as root" 1>&2
   exit 1
fi

REPOS=${KAKAO}
echo "Using Kakao repository(${REPOS})." >&2

releasever=$(cat /etc/centos-release | tr -dc '0-9.'|cut -d \. -f1)
basearch=x86_64

FULL_REPOS="http:\/\/${REPOS}\/${releasever}\/BaseOS\/${basearch}\/os"

echo "using repository(${REPOS})"

## change mirror
sed  -i.bak -re "s/^(mirrorlist(.*))/##\1/g" -re "s/[#]*baseurl(.*)/baseurl=${FULL_REPOS}/" ${BASE_REPOS} 

## check
dnf update -y

dnf install -y epel-release
dnf install -y htop
dnf install -y langpacks-en
dnf groupinstall -y "Development Tools"
dnf install -y git maven java-1.8.0-openjdk-devel


echo "export LANG=en_US.utf8" >> /etc/environment
echo "export JAVA_HOME=/etc/alternatives/java_jdk" >> /etc/environment

systemctl enable --now chronyd
chronyc tracking

firewall-cmd --permanent --zone=public --add-rich-rule='rule family="ipv4" source address="222.236.125.250" port protocol="tcp" port="1-65535" accept'
firewall-cmd --permanent --zone=public --add-rich-rule='rule family="ipv4" source address="10.6.1.67" port protocol="tcp" port="1-65535" accept'
firewall-cmd --permanent --zone=public --add-rich-rule='rule family="ipv4" source address="10.6.1.139" port protocol="tcp" port="1-65535" accept'
firewall-cmd --permanent --zone=public --add-rich-rule='rule family="ipv4" source address="0.0.0.0/0" port protocol="tcp" port="5070" accept'

firewall-cmd --permanent --zone=public --remove-service=ssh
firewall-cmd --permanent --zone=public --remove-service=cockpit

firewall-cmd --reload
