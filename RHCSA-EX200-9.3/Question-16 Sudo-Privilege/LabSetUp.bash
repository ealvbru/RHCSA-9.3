#!/bin/bash
echo "============================================="
echo " Lab Setup — Q16: Sudo Privilege"
echo "============================================="
# Remove any previous admin sudo config
rm -f /etc/sudoers.d/admin 2>/dev/null
sed -i '/%admin/d' /etc/sudoers 2>/dev/null
echo "Cleaned up previous sudo config for admin group."
echo "Ensure group admin and users exist (see Q3)."
echo "Lab setup complete. Read Questions.bash for the task."
