#!/bin/bash
cat <<'EOF'
╔══════════════════════════════════════════════════════════════════╗
║  QUESTION 3 — Create Users and Group (serverb)                  ║
╠══════════════════════════════════════════════════════════════════╣
║                                                                  ║
║  a) Create a group called "admin"                               ║
║                                                                  ║
║  b) Create the following users:                                 ║
║     - harry  → member of supplementary group "admin"            ║
║     - natasha → member of supplementary group "admin"           ║
║     - sarah  → cannot log in interactively (nologin shell)      ║
║                                                                  ║
║  c) Set the password for all three users to: Password           ║
║                                                                  ║
╚══════════════════════════════════════════════════════════════════╝
EOF
