#!/bin/bash
cat <<'EOF'
╔══════════════════════════════════════════════════════════════════╗
║  QUESTION 20 — Create a Swap Partition (servera)                ║
╠══════════════════════════════════════════════════════════════════╣
║                                                                  ║
║  ** This task is performed on servera.lab.example.com **        ║
║                                                                  ║
║  Create a swap partition with the following specifications:     ║
║                                                                  ║
║  a) Create a 512 MiB swap partition on disk /dev/vdb            ║
║  b) Format it as swap                                           ║
║  c) Mount it permanently (survives reboot via /etc/fstab)       ║
║  d) Activate the swap immediately                               ║
║                                                                  ║
╚══════════════════════════════════════════════════════════════════╝
EOF
