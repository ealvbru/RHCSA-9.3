#!/bin/bash
cat <<'EOF'
╔══════════════════════════════════════════════════════════════════╗
║  SOLUTION — Q3: Create Users and Group                          ║
╠══════════════════════════════════════════════════════════════════╣

Step 1: Create the group
  groupadd admin

Step 2: Create users
  useradd -G admin harry
  useradd -G admin natasha
  useradd -s /sbin/nologin sarah

Step 3: Set passwords for all users
  echo "Password" | passwd --stdin harry
  echo "Password" | passwd --stdin natasha
  echo "Password" | passwd --stdin sarah

Step 4: Verify
  id harry       # Should show groups: harry admin
  id natasha     # Should show groups: natasha admin
  id sarah       # Should show shell: /sbin/nologin
  grep sarah /etc/passwd   # Should show /sbin/nologin

╚══════════════════════════════════════════════════════════════════╝
EOF
