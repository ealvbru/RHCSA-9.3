#!/bin/bash
cat <<'EOF'
╔══════════════════════════════════════════════════════════════════╗
║  SOLUTION — Q15: Set Password Expiry Policy                     ║
╠══════════════════════════════════════════════════════════════════╣

Step 1: Edit /etc/login.defs
  vim /etc/login.defs
  # Find the line: PASS_MAX_DAYS  99999
  # Change to:     PASS_MAX_DAYS  20

Step 2: Verify
  grep PASS_MAX_DAYS /etc/login.defs
  # Should show: PASS_MAX_DAYS  20

  # Test by creating a new user:
  useradd testexpiry
  chage -l testexpiry
  # "Maximum number of days between password change" should be 20
  userdel -r testexpiry

╚══════════════════════════════════════════════════════════════════╝
EOF
