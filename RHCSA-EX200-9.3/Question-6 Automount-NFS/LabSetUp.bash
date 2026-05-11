#!/bin/bash
echo "============================================="
echo " Lab Setup — Q6: Automount NFS"
echo "============================================="
echo ""
echo "Installing autofs..."
dnf install -y autofs nfs-utils 2>/dev/null
echo ""
echo "Creating user production5 (if not exists)..."
useradd production5 2>/dev/null
echo "redhat" | passwd --stdin production5 2>/dev/null
echo ""
echo "Lab setup complete. Read Questions.bash for the task."
echo "Note: servera must be exporting /user-homes/production5 via NFS."
