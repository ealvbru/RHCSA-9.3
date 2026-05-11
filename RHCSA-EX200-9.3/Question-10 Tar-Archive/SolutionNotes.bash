#!/bin/bash
cat <<'EOF'
╔══════════════════════════════════════════════════════════════════╗
║  SOLUTION — Q10: Create a Tar Archive                           ║
╠══════════════════════════════════════════════════════════════════╣

Step 1: Create gzip-compressed archive
  tar -zcvf /root/test.tar.gz /var/tmp

Step 2: Create bzip2-compressed archive
  tar -jcvf /root/test.tar.bz2 /var/tmp

Step 3: Verify
  file /root/test.tar.gz     # Should show gzip compressed
  file /root/test.tar.bz2    # Should show bzip2 compressed
  tar -tzf /root/test.tar.gz | head
  tar -tjf /root/test.tar.bz2 | head

╚══════════════════════════════════════════════════════════════════╝
EOF
