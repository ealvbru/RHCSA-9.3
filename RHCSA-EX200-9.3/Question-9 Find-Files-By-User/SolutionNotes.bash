#!/bin/bash
cat <<'EOF'
╔══════════════════════════════════════════════════════════════════╗
║  SOLUTION — Q9: Locate Files Owned by User                      ║
╠══════════════════════════════════════════════════════════════════╣

Step 1: Create the destination directory
  mkdir -p /root/myfinds

Step 2: Find and copy all files owned by sarah
  find / -user sarah -type f -exec cp {} /root/myfinds/ \; 2>/dev/null

Step 3: Verify
  ls -la /root/myfinds/
  # Should contain copies of all files owned by sarah

╚══════════════════════════════════════════════════════════════════╝
EOF
