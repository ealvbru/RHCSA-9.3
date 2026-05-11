#!/bin/bash
echo "============================================="
echo " Lab Setup — Q17: Login Message"
echo "============================================="
echo "Ensure user alies exists (see Q8)."
if id alies &>/dev/null; then
  # Reset bash_profile to default
  cp /etc/skel/.bash_profile /home/alies/.bash_profile 2>/dev/null
  chown alies:alies /home/alies/.bash_profile 2>/dev/null
fi
echo "Lab setup complete. Read Questions.bash for the task."
