#!/bin/bash

proxy_domain=squid.private.litware.com

echo "export HTTP_PROXY=$proxy_domain" >> ~/.bashrc
echo "export HTTPS_PROXY=$proxy_domain" >> ~/.bashrc 
