#!/bin/bash
echo "============================================="
echo " Lab Setup — Q10: Tar Archive"
echo "============================================="
rm -f /root/test.tar.gz /root/test.tar.bz2 2>/dev/null
# Create some content in /var/tmp
mkdir -p /var/tmp/testdata
echo "sample data" > /var/tmp/testdata/sample.txt
echo "Lab setup complete. Read Questions.bash for the task."
