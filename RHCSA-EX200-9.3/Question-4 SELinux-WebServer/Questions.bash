#!/bin/bash
cat <<'EOF'
╔══════════════════════════════════════════════════════════════════╗
║  QUESTION 4 — Configure SELinux for Web Server (serverb)        ║
╠══════════════════════════════════════════════════════════════════╣
║                                                                  ║
║  A web server running on serverb is having issues serving       ║
║  content on a non-standard port.                                ║
║                                                                  ║
║  Requirements:                                                   ║
║  a) The web server must serve content from /var/www/html        ║
║  b) Do NOT alter or remove any existing files in that directory ║
║  c) The web server must listen on port 82                       ║
║  d) The content must be accessible (SELinux, firewall, service) ║
║                                                                  ║
║  Hints:                                                          ║
║  - Install httpd if not present                                 ║
║  - Configure SELinux to allow port 82 for HTTP                  ║
║  - Open the firewall for port 82                                ║
║  - Ensure httpd is enabled and started                          ║
║                                                                  ║
╚══════════════════════════════════════════════════════════════════╝
EOF
