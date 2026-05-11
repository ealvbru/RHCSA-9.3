#!/bin/bash
echo "============================================="
echo " Lab Setup — Q15: Password Expiry"
echo "============================================="
# Reset to default
sed -i 's/^PASS_MAX_DAYS.*/PASS_MAX_DAYS\t99999/' /etc/login.defs 2>/dev/null
echo "Reset PASS_MAX_DAYS to default (99999)."
echo "Lab setup complete. Read Questions.bash for the task."
