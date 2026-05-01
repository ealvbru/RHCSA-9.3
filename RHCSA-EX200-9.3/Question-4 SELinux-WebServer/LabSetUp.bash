#!/bin/bash
echo "============================================="
echo " Lab Setup — Q4: SELinux WebServer"
echo "============================================="
echo ""
echo "Installing httpd and creating test content..."
dnf install -y httpd 2>/dev/null
echo "<h1>RHCSA Test Page on Port 82</h1>" > /var/www/html/index.html
restorecon -Rv /var/www/html/ 2>/dev/null
# Set httpd to listen on port 82 (but don't fix SELinux — that's the task)
sed -i 's/^Listen 80$/Listen 82/' /etc/httpd/conf/httpd.conf 2>/dev/null
systemctl stop httpd 2>/dev/null
echo ""
echo "Lab setup complete. The web server is configured to listen on"
echo "port 82 but cannot start due to SELinux restrictions."
echo "Read Questions.bash for the task."
