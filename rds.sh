#!/bin/bash
yum update -y
yum install -y httpd
systemctl start httpd
systemctl enable httpd
echo "<h1>My only motto about life is don't lose $(hostname -f)</h1>" > /var/www/html/index.html
my very first projects