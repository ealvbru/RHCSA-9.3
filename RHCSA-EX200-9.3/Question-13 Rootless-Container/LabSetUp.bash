#!/bin/bash
echo "============================================="
echo " Lab Setup — Q13: Rootless Container"
echo "============================================="
echo "Installing podman..."
dnf install -y podman 2>/dev/null
echo "Creating user student..."
useradd student 2>/dev/null
echo "redhat" | passwd --stdin student 2>/dev/null
echo "Creating mount directories..."
mkdir -p /opt/files /opt/processed
chmod 777 /opt/files /opt/processed
echo ""
echo "Lab setup complete."
echo "Switch to user student: su - student"
echo "Read Questions.bash for the task."
