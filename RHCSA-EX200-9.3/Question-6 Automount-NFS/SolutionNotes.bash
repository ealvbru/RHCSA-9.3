#!/bin/bash
cat <<'EOF'
╔══════════════════════════════════════════════════════════════════╗
║  SOLUTION — Q6: Automount Remote User Home Directory             ║
╠══════════════════════════════════════════════════════════════════╣

╔══════════════════════════════════════════════════════════════════╗
║  SOLUTION — Q6: servera                                          ║
╠══════════════════════════════════════════════════════════════════╣

Step 1: Ensure the user exists on servera
# useradd production5

Step 2: Ensure the home directory path matches the requirement
# mkdir -p /user-homes/production5
#chown production5:production5 /user-homes/production5

Step 3: You must expose the directory to the network via /etc/exports.
Open /etc/exports on servera and add the following entry to allow serverb (or your entire classroom subnet) to mount it read-write:

/user-homes/production5   serverb.lab.example.com(rw,sync,no_root_squash)

- rw: Gives read-write access (Requirement C).
- sync: Forces data to be written to disks immediately to ensure synchronization.
- no_root_squash: Allows root users on the client side to retain root privileges when manipulating files (very common for administrative convenience in home directory hosting).

After saving the file, apply the configuration live:

# exportfs -rav

Step 4: Start & Enable NFS Services
The NFS kernel server daemon must be active to answer mount requests:

# systemctl enable --now nfs-server

Step 5: Open the Firewall
The server's firewall must explicitly allow incoming NFS protocol traffic:

# firewall-cmd --permanent --add-service=nfs
# firewall-cmd --permanent --add-service=rpc-bind
# firewall-cmd --permanent --add-service=mountd
# firewall-cmd --reload

Step 6: How to test servera from serverb
Before you even configure autofs, you can verify if servera is sharing the folder correctly by running this command from serverb:

# showmount -e servera.lab.example.com

╔══════════════════════════════════════════════════════════════════╗
║  SOLUTION — Q6: serverb                                          ║
╠══════════════════════════════════════════════════════════════════╣

Step 1: Install autofs
  dnf install -y autofs nfs-utils

Step 2: Configure the master map
  vim /etc/auto.master
  # Add the line:
  /localhome  /etc/auto.production

Step 3: Create the indirect map file
  vim /etc/auto.production
  # Add the line:
  production5  -rw,soft,intr  servera.lab.example.com:/user-homes/production5

Step 4: Start and enable autofs
  systemctl restart autofs
  systemctl enable autofs

Step 5: Verify
  ls /localhome/production5     # Should trigger automount
  su - production5              # Should login with home at /localhome/production5
  mount | grep production5      # Should show NFS mount

╚══════════════════════════════════════════════════════════════════╝
EOF
