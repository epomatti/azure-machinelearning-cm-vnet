#!/bin/sh

export DEBIAN_FRONTEND=noninteractive
export NEEDRESTART_MODE=a

# Update
apt update
apt upgrade -y

apt install squid -y
# apt install nginx -y

cp /etc/squid/squid.conf /etc/squid/squid.conf.original
chmod a-w /etc/squid/squid.conf.original


reboot
