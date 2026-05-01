#!/bin/bash
cat <<'EOF'
╔══════════════════════════════════════════════════════════════════╗
║  SOLUTION — Q17: Configure Login Message                        ║
╠══════════════════════════════════════════════════════════════════╣

Step 1: Edit alies's bash_profile
  vim /home/alies/.bash_profile
  # Add at the end of the file:
  RHCSA="Welcome to Exam Training"
  echo $RHCSA

  # OR simply:
  echo "Welcome to Exam Training"

Step 2: Verify
  su - alies
  # Should display: Welcome to Exam Training

╚══════════════════════════════════════════════════════════════════╝
EOF
