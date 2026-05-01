#!/bin/bash
cat <<'EOF'
╔══════════════════════════════════════════════════════════════════╗
║  SOLUTION — Q22: Resize the Logical Volume                      ║
╠══════════════════════════════════════════════════════════════════╣

** All steps on servera **

Step 1: Check current size
  df -h /mnt/Software
  lvdisplay /dev/Developer/Engineer

Step 2: Resize the LV and filesystem together
  lvextend -L 500M -r /dev/mapper/Developer-Engineer
  # The -r flag automatically resizes the filesystem (resize2fs for ext3)

  # If -r doesn't work, do it manually:
  # lvextend -L 500M /dev/mapper/Developer-Engineer
  # resize2fs /dev/mapper/Developer-Engineer

Step 3: Verify
  df -h /mnt/Software
  # Should show approximately 500M (between 500M-600M)
  lvdisplay /dev/Developer/Engineer
  # LV Size should be ~504.00 MiB (rounded to PE boundary)
  lsblk
  # Should show Developer-Engineer with ~504M

╚══════════════════════════════════════════════════════════════════╝
EOF
