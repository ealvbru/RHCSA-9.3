#!/bin/bash
cat <<'EOF'
╔══════════════════════════════════════════════════════════════════╗
║  QUESTION 19 — Break/Reset the Root Password (servera)          ║
╠══════════════════════════════════════════════════════════════════╣
║                                                                  ║
║  ** This task is performed on servera.lab.example.com **        ║
║                                                                  ║
║  The root password on servera has been lost.                    ║
║  Reset the root password to: NorTh@te                           ║
║                                                                  ║
║  Requirements:                                                   ║
║  a) Reset the root password to NorTh@te                         ║
║  b) Ensure the system boots normally after the reset            ║
║  c) Enable SSH root login (PermitRootLogin yes)                 ║
║  d) Ensure SELinux relabeling occurs (touch /.autorelabel)      ║
║                                                                  ║
║  Hint: You need to interrupt the boot process and use           ║
║  emergency/rescue mode (rd.break).                              ║
║                                                                  ║
╚══════════════════════════════════════════════════════════════════╝
EOF
