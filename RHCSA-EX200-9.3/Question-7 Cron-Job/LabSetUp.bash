#!/bin/bash
echo "============================================="
echo " Lab Setup — Q7: Cron Job"
echo "============================================="
echo "Removing any existing crontab for harry..."
crontab -r -u harry 2>/dev/null
echo "Ensure user harry exists (see Q3)."
echo "Lab setup complete. Read Questions.bash for the task."
