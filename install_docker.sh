#!/usr/bin/env bash

sudo yum remove docker docker-client docker-client-latest docker-common docker-latest docker-latest-logrotate docker-logrotate docker-engine
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo yum install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo systemctl enable --now docker
wget https://download.sharenshare.kr/docker-compose-linux-x86_64 -o /usr/bin/docker-compose
chmod +x /usr/bin/docker-compose
