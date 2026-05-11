#!/bin/bash
cat <<'EOF'
╔══════════════════════════════════════════════════════════════════╗
║  QUESTION 14 — Set Permissions with umask (serverb)             ║
╠══════════════════════════════════════════════════════════════════╣
║                                                                  ║
║  Configure the default file creation permissions for user       ║
║  natasha:                                                        ║
║                                                                  ║
║  a) All new files created by natasha should have permissions:   ║
║     -r--------  (0400)                                          ║
║                                                                  ║
║  b) All new directories created by natasha should have:         ║
║     dr-x------  (0500)                                          ║
║                                                                  ║
║  Hint: This requires setting the correct umask value.           ║
║                                                                  ║
╚══════════════════════════════════════════════════════════════════╝
EOF
