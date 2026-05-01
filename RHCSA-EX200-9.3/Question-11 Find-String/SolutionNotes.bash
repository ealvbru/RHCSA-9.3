#!/bin/bash
cat <<'EOF'
╔══════════════════════════════════════════════════════════════════╗
║  SOLUTION — Q11: Find the String                                ║
╠══════════════════════════════════════════════════════════════════╣

Step 1: Use grep to find lines containing "home"
  grep "home" /etc/passwd > /root/search.txt

Step 2: Verify
  cat /root/search.txt
  # All lines should contain "home" and be in same order as /etc/passwd
  diff <(grep "home" /etc/passwd) /root/search.txt
  # Should show no differences

╚══════════════════════════════════════════════════════════════════╝
EOF
