#!/bin/bash
echo "============================================="
echo " Lab Setup — Q3: Create Users and Group"
echo "============================================="
echo ""
echo "Cleaning up any existing users/groups from previous attempts..."
userdel -r harry 2>/dev/null
userdel -r natasha 2>/dev/null
userdel -r sarah 2>/dev/null
groupdel admin 2>/dev/null
echo "Cleanup complete."
echo ""
echo "Lab setup complete. Read Questions.bash for the task."
