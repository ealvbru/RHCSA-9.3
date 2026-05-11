#!/bin/bash
cat <<'EOF'
╔══════════════════════════════════════════════════════════════════╗
║  SOLUTION — Q6: Automount Remote User Home Directory            ║
╠══════════════════════════════════════════════════════════════════╣

Step 1: Install autofs
  dnf install -y autofs nfs-utils

Step 2: Configure the master map
  vim /etc/auto.master
  # Add the line:
  /localhome  /etc/auto.production

Step 3: Create the indirect map file
  vim /etc/auto.production
  # Add the line:
  production5  -rw,soft,intr  servera.lab.example.com:/user-homes/production5

Step 4: Start and enable autofs
  systemctl restart autofs
  systemctl enable autofs

Step 5: Verify
  ls /localhome/production5     # Should trigger automount
  su - production5              # Should login with home at /localhome/production5
  mount | grep production5      # Should show NFS mount

╚══════════════════════════════════════════════════════════════════╝
EOF
