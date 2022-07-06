#!/usr/bin/env bash

if [ "$(id -u)" != "0" ]; then
   echo "'$0' must be run as root" 1>&2
   exit 1
fi

## check
dnf update -y

dnf install -y epel-release
dnf install -y htop
dnf install -y langpacks-en
dnf groupinstall -y "Development Tools"
dnf install -y java-1.8.0-openjdk-devel git maven

echo "export LANG=en_US.utf8" >> /etc/environment
echo "export JAVA_HOME=/etc/alternatives/java_sdk" >> /etc/environment

systemctl enable --now chronyd
systemctl disable --now firewalld
chronyc tracking
