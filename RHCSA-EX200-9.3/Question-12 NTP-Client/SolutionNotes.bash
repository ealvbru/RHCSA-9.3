#!/bin/bash
cat <<'EOF'
╔══════════════════════════════════════════════════════════════════╗
║  SOLUTION — Q12: Configure NTP Client                           ║
╠══════════════════════════════════════════════════════════════════╣

Step 1: Edit chrony configuration
  vim /etc/chrony.conf
  # Add the line (or replace existing server/pool lines):
  server classroom.example.com iburst

Step 2: Restart and enable chronyd
  systemctl restart chronyd
  systemctl enable chronyd

Step 3: Verify
  chronyc sources
  # Should show classroom.example.com as a source
  timedatectl
  # "NTP service: active" should be shown

╚══════════════════════════════════════════════════════════════════╝
EOF
