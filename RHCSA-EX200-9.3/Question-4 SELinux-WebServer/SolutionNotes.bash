#!/bin/bash
cat <<'EOF'
╔══════════════════════════════════════════════════════════════════╗
║  SOLUTION — Q4: Configure SELinux for Web Server                ║
╠══════════════════════════════════════════════════════════════════╣

Step 1: Install httpd (if not already installed)
  dnf install -y httpd

Step 2: Configure httpd to listen on port 82
  vim /etc/httpd/conf/httpd.conf
  # Change: Listen 80  →  Listen 82

Step 3: Add SELinux port rule for HTTP on port 82
  semanage port -a -t http_port_t -p tcp 82
  # If it says "already defined", use -m instead of -a:
  # semanage port -m -t http_port_t -p tcp 82

Step 4: Open the firewall
  firewall-cmd --permanent --add-port=82/tcp
  firewall-cmd --reload

Step 5: Restore SELinux context on web content
  restorecon -Rv /var/www/html

Step 6: Enable and start httpd
  systemctl enable --now httpd

Step 7: Verify
  curl http://localhost:82
  semanage port -l | grep http_port_t
  firewall-cmd --list-ports

╚══════════════════════════════════════════════════════════════════╝
EOF
