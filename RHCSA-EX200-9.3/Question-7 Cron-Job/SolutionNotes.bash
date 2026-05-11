#!/bin/bash
cat <<'EOF'
╔══════════════════════════════════════════════════════════════════╗
║  SOLUTION — Q7: Create a Cron Job                               ║
╠══════════════════════════════════════════════════════════════════╣

Step 1: Edit harry's crontab
  crontab -eu harry

Step 2: Add the following line:
  23 14 * * * logger -p user.debug "RHCSA"

Step 3: Verify
  crontab -lu harry
  # Should show: 23 14 * * * logger -p user.debug "RHCSA"

╚══════════════════════════════════════════════════════════════════╝
EOF
