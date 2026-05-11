#!/bin/bash
cat <<'EOF'
╔══════════════════════════════════════════════════════════════════╗
║  SOLUTION — Q14: Set Permissions with umask                     ║
╠══════════════════════════════════════════════════════════════════╣

  The desired permissions:
    Files:       -r--------  (0400)  → umask = 0666 - 0400 = 0266
    Directories: dr-x------  (0500)  → umask = 0777 - 0500 = 0277

  Since umask is a single value, use 0277:
    Files:       0666 & ~0277 = 0400  ✓  (-r--------)
    Directories: 0777 & ~0277 = 0500  ✓  (dr-x------)

Step 1: Edit natasha's bash_profile
  vim /home/natasha/.bash_profile
  # Add at the end:
  umask 0277

Step 2: Verify
  su - natasha
  touch /tmp/testfile-natasha
  ls -l /tmp/testfile-natasha     # Should show -r--------
  mkdir /tmp/testdir-natasha
  ls -ld /tmp/testdir-natasha     # Should show dr-x------

╚══════════════════════════════════════════════════════════════════╝
EOF
