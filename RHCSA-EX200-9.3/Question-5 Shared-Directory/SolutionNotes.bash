#!/bin/bash
cat <<'EOF'
╔══════════════════════════════════════════════════════════════════╗
║  SOLUTION — Q5: Create Collaborative Directory                  ║
╠══════════════════════════════════════════════════════════════════╣

Step 1: Create the directory structure
  mkdir -p /common/shared

Step 2: Set group ownership to admin
  chgrp admin /common/shared

Step 3: Set permissions (rwx for owner and group, none for others)
  chmod 770 /common/shared

Step 4: Set the SGID bit (new files inherit group)
  chmod g+s /common/shared

Step 5: Verify
  ls -ld /common/shared
  # Expected: drwxrws--- root admin /common/shared

  # Test as harry:
  su - harry -c "touch /common/shared/testfile"
  ls -l /common/shared/testfile
  # File should have group "admin"

╚══════════════════════════════════════════════════════════════════╝
EOF
