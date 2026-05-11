#!/bin/bash
cat <<'EOF'
╔══════════════════════════════════════════════════════════════════╗
║  SOLUTION — Q20: Create a Swap Partition                        ║
╠══════════════════════════════════════════════════════════════════╣

** All steps on servera **

Step 1: Check available disks
  lsblk

Step 2: Create a partition on /dev/vdb
  fdisk /dev/vdb
    n        → new partition
    p        → primary
    1        → partition number 1
    (Enter)  → default first sector
    +512M    → size 512 MiB
    t        → change type
    swap     → (or 82 for Linux swap)
    w        → write and exit

Step 3: Format as swap
  mkswap /dev/vdb1

Step 4: Add to /etc/fstab for persistence
  vim /etc/fstab
  # Add the line:
  /dev/vdb1   swap   swap   defaults   0 0

Step 5: Activate swap
  swapon -a

Step 6: Verify
  free -h
  # Swap line should show ~511Mi
  swapon --show
  # Should show /dev/vdb1

╚══════════════════════════════════════════════════════════════════╝
EOF
