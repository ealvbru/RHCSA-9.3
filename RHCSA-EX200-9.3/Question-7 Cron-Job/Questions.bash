#!/bin/bash
cat <<'EOF'
╔══════════════════════════════════════════════════════════════════╗
║  QUESTION 7 — Create a Cron Job (serverb)                       ║
╠══════════════════════════════════════════════════════════════════╣
║                                                                  ║
║  Create a cron job for user harry that runs the following       ║
║  command every day at 14:23:                                    ║
║                                                                  ║
║    logger -p user.debug "RHCSA"                                 ║
║                                                                  ║
║  Requirements:                                                   ║
║  a) The cron job must run as user harry                         ║
║  b) It must execute at exactly 14:23 every day                  ║
║  c) The command must be: logger -p user.debug "RHCSA"           ║
║                                                                  ║
╚══════════════════════════════════════════════════════════════════╝
EOF
