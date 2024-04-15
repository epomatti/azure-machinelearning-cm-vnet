#!/bin/bash

echo "Script starting..."

set -e

proxy_domain=squid.private.litware.com

echo "Applying proxy..."

sudo -u azureuser echo "export HTTP_PROXY=$proxy_domain" >> ~/.bashrc
sudo -u azureuser echo "export HTTPS_PROXY=$proxy_domain" >> ~/.bashrc

sudo -u azureuser echo "export http_proxy=$proxy_domain" >> ~/.bashrc
sudo -u azureuser echo "export https_proxy=$proxy_domain" >> ~/.bashrc

sudo -u azureuser echo "export https_proxy=$proxy_domain" >> ~/.echo.test
sudo -u azureuser echo "export https_proxy=$proxy_domain" >> /tmp/echo.test

echo "Script complete"
