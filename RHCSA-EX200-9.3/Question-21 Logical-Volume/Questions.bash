#!/bin/bash
cat <<'EOF'
╔══════════════════════════════════════════════════════════════════╗
║  QUESTION 21 — Create a Logical Volume (servera)                ║
╠══════════════════════════════════════════════════════════════════╣
║                                                                  ║
║  ** This task is performed on servera.lab.example.com **        ║
║                                                                  ║
║  Create a logical volume with the following specifications:     ║
║                                                                  ║
║  a) Create a new partition on /dev/vdb (2G, type LVM)           ║
║                                                                  ║
║  b) Create a Volume Group named "Developer" with:               ║
║     - Physical extent size: 8 MiB                               ║
║     - Using the new LVM partition                               ║
║                                                                  ║
║  c) Create a Logical Volume named "Engineer" with:              ║
║     - Size: 50 extents                                          ║
║     - Filesystem: ext3                                          ║
║                                                                  ║
║  d) Mount the logical volume permanently at /mnt/Software       ║
║                                                                  ║
╚══════════════════════════════════════════════════════════════════╝
EOF
