#!/bin/bash
cat <<'EOF'
╔══════════════════════════════════════════════════════════════════╗
║  SOLUTION — Q16: Assign Sudo Privilege                          ║
╠══════════════════════════════════════════════════════════════════╣

Method 1: Using visudo (recommended)
  visudo
  # Add the line:
  %admin  ALL=(ALL)  NOPASSWD: ALL

Method 2: Using a drop-in file
  echo '%admin  ALL=(ALL)  NOPASSWD: ALL' > /etc/sudoers.d/admin
  chmod 440 /etc/sudoers.d/admin

Verify:
  su - harry
  sudo whoami        # Should return "root" without password prompt
  sudo cat /etc/shadow   # Should work without password

╚══════════════════════════════════════════════════════════════════╝
EOF
