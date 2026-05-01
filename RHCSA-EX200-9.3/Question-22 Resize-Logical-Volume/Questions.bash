#!/bin/bash
cat <<'EOF'
╔══════════════════════════════════════════════════════════════════╗
║  QUESTION 22 — Resize the Logical Volume (servera)              ║
╠══════════════════════════════════════════════════════════════════╣
║                                                                  ║
║  ** This task is performed on servera.lab.example.com **        ║
║                                                                  ║
║  Resize the logical volume /dev/Developer/Engineer              ║
║  (mounted at /mnt/Software) to 500 MiB.                        ║
║                                                                  ║
║  Requirements:                                                   ║
║  a) The final LVM size should be between 500M and 600M         ║
║     (acceptable range)                                          ║
║  b) The filesystem must be resized along with the LV            ║
║  c) The data on the filesystem must NOT be lost                 ║
║  d) The mount must remain functional after resize               ║
║                                                                  ║
║  Note: Q21 (Create Logical Volume) must be completed first.     ║
║                                                                  ║
╚══════════════════════════════════════════════════════════════════╝
EOF
