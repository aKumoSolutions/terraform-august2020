#!/bin/bash
yum install httpd -y
echo "Hello from ${env} environment!!" >> /var/www/html/index.html
systemctl start httpd