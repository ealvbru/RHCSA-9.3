#!/bin/bash
cat <<'EOF'
╔══════════════════════════════════════════════════════════════════╗
║  QUESTION 6 — Automount Remote User Home Directory (serverb)    ║
╠══════════════════════════════════════════════════════════════════╣
║                                                                  ║
║  A remote user "production5" has a home directory on servera.   ║
║  Configure autofs to automatically mount it.                    ║
║                                                                  ║
║  Requirements:                                                   ║
║  a) NFS export: servera.lab.example.com:/user-homes/production5 ║
║  b) Mount locally at: /localhome/production5                    ║
║  c) Mount with read-write permissions                           ║
║  d) The user production5 password is: redhat                    ║
║  e) The mount must work automatically when accessing the path   ║
║                                                                  ║
║  Hint: Use autofs to configure indirect automounting.           ║
║                                                                  ║
╚══════════════════════════════════════════════════════════════════╝
EOF
