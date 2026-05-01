#!/bin/bash
cat <<'EOF'
╔══════════════════════════════════════════════════════════════════╗
║  SOLUTION — Q18: Create a Script File                           ║
╠══════════════════════════════════════════════════════════════════╣

Step 1: Create the script
  vim /usr/local/bin/mysearch

  #!/bin/bash
  find /usr/share -type f -size -1M > /root/myfiles

Step 2: Make it executable
  chmod +x /usr/local/bin/mysearch

Step 3: Run the script
  mysearch
  # OR: /usr/local/bin/mysearch

Step 4: Verify
  ls -la /usr/local/bin/mysearch   # Should be executable
  cat /root/myfiles | head         # Should list files from /usr/share
  wc -l /root/myfiles              # Should have many lines

╚══════════════════════════════════════════════════════════════════╝
EOF
