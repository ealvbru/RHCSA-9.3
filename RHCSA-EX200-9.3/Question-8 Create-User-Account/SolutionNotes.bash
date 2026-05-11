#!/bin/bash
cat <<'EOF'
╔══════════════════════════════════════════════════════════════════╗
║  SOLUTION — Q8: Create a User Account                           ║
╠══════════════════════════════════════════════════════════════════╣

Step 1: Create the user with specific UID
  useradd -u 1326 alies

Step 2: Set the password
  echo "Password" | passwd --stdin alies

Step 3: Verify
  id alies
  # Should show uid=1326(alies)

╚══════════════════════════════════════════════════════════════════╝
EOF
