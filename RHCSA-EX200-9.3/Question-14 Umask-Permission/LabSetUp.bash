#!/bin/bash
echo "============================================="
echo " Lab Setup — Q14: Umask Permission"
echo "============================================="
echo "Ensure user natasha exists (see Q3)."
# Remove any previous umask setting
if id natasha &>/dev/null; then
  sed -i '/^umask/d' /home/natasha/.bash_profile 2>/dev/null
  sed -i '/^umask/d' /home/natasha/.bashrc 2>/dev/null
fi
echo "Lab setup complete. Read Questions.bash for the task."
