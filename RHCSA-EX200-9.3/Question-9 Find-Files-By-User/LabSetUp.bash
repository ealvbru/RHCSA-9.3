#!/bin/bash
echo "============================================="
echo " Lab Setup — Q9: Find Files By User"
echo "============================================="
rm -rf /root/myfinds 2>/dev/null
# Create some files owned by sarah for the exercise
if id sarah &>/dev/null; then
  mkdir -p /tmp/sarah-files
  touch /tmp/sarah-files/file1.txt /tmp/sarah-files/file2.txt
  chown sarah:sarah /tmp/sarah-files/file1.txt /tmp/sarah-files/file2.txt
  echo "Created sample files owned by sarah in /tmp/sarah-files/"
fi
echo "Lab setup complete. Read Questions.bash for the task."
