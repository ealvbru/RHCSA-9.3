#!/bin/bash
cat <<'EOF'
╔══════════════════════════════════════════════════════════════════╗
║  SOLUTION — Q21: Create a Logical Volume                        ║
╠══════════════════════════════════════════════════════════════════╣

** All steps on servera **

Step 1: Create a 2G LVM partition on /dev/vdb
  fdisk /dev/vdb
    n        → new partition
    p        → primary
    2        → partition number 2
    (Enter)  → default first sector
    +2G      → size 2 GiB
    t        → change type
    2        → select partition 2
    lvm      → (or 8e for Linux LVM)
    w        → write and exit

Step 2: Create the Volume Group
  vgcreate -s 8M Developer /dev/vdb2

Step 3: Create the Logical Volume (50 extents × 8MiB = 400MiB)
  lvcreate -l 50 -n Engineer Developer

Step 4: Format with ext3
  mkfs.ext3 /dev/Developer/Engineer

Step 5: Create mount point and add to fstab
  mkdir -p /mnt/Software
  vim /etc/fstab
  # Add the line:
  /dev/Developer/Engineer  /mnt/Software  ext3  defaults  0 0

Step 6: Mount
  mount -a

Step 7: Verify
  lsblk
  df -h /mnt/Software
  # Should show ~400M mounted at /mnt/Software
  vgdisplay Developer | grep "PE Size"
  # Should show 8.00 MiB
  lvdisplay /dev/Developer/Engineer | grep "Current LE"
  # Should show 50

╚══════════════════════════════════════════════════════════════════╝
EOF
