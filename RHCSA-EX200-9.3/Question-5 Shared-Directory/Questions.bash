#!/bin/bash
cat <<'EOF'
╔══════════════════════════════════════════════════════════════════╗
║  QUESTION 5 — Create Collaborative Directory (serverb)          ║
╠══════════════════════════════════════════════════════════════════╣
║                                                                  ║
║  Create a collaborative directory /common/shared with the       ║
║  following requirements:                                         ║
║                                                                  ║
║  a) Group members harry and natasha can read, write, and        ║
║     access files in /common/shared                              ║
║                                                                  ║
║  b) Any new files created in /common/shared automatically       ║
║     inherit the group ownership "admin"                         ║
║     (Set-GID bit must be set)                                   ║
║                                                                  ║
║  c) Other users (not in admin group) should NOT be able to      ║
║     access /common/shared at all                                ║
║                                                                  ║
║  Note: Users harry and natasha must already exist (see Q3).     ║
║                                                                  ║
╚══════════════════════════════════════════════════════════════════╝
EOF
