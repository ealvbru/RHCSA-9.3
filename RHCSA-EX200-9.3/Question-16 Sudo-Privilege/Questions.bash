#!/bin/bash
cat <<'EOF'
╔══════════════════════════════════════════════════════════════════╗
║  QUESTION 16 — Assign Sudo Privilege (serverb)                  ║
╠══════════════════════════════════════════════════════════════════╣
║                                                                  ║
║  Configure sudo access for the group "admin" so that all       ║
║  members can run any command as any user WITHOUT being          ║
║  prompted for a password.                                       ║
║                                                                  ║
║  Requirements:                                                   ║
║  a) Group "admin" members get full sudo access                  ║
║  b) No password prompt when using sudo                          ║
║  c) The configuration must persist after reboot                 ║
║                                                                  ║
╚══════════════════════════════════════════════════════════════════╝
EOF
