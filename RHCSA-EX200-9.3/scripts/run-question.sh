#!/bin/bash
###############################################################################
#  RHCSA EX200 9.3 — Question Runner
#  Usage:
#    bash run-question.sh "Question-1 Configure-Network"
#    bash run-question.sh --list
###############################################################################

BASE_DIR="$(cd "$(dirname "$0")/.." && pwd)"

if [[ "$1" == "--list" || -z "$1" ]]; then
  echo ""
  echo "  RHCSA EX200 9.3 — Available Questions"
  echo "  ======================================="
  echo ""
  echo "  SERVERB (serverb.lab.example.com):"
  echo "    Q1   Configure-Network"
  echo "    Q2   Configure-Repository"
  echo "    Q3   Create-Users-Group"
  echo "    Q4   SELinux-WebServer"
  echo "    Q5   Shared-Directory"
  echo "    Q6   Automount-NFS"
  echo "    Q7   Cron-Job"
  echo "    Q8   Create-User-Account"
  echo "    Q9   Find-Files-By-User"
  echo "    Q10  Tar-Archive"
  echo "    Q11  Find-String"
  echo "    Q12  NTP-Client"
  echo "    Q13  Rootless-Container"
  echo "    Q14  Umask-Permission"
  echo "    Q15  Password-Expiry"
  echo "    Q16  Sudo-Privilege"
  echo "    Q17  Login-Message"
  echo "    Q18  Create-Script"
  echo ""
  echo "  SERVERA (servera.lab.example.com):"
  echo "    Q19  Break-Root-Password"
  echo "    Q20  Swap-Partition"
  echo "    Q21  Logical-Volume"
  echo "    Q22  Resize-Logical-Volume"
  echo ""
  echo "  Usage:"
  echo "    bash scripts/run-question.sh \"Question-1 Configure-Network\""
  echo ""
  exit 0
fi

QUESTION_DIR="$BASE_DIR/$1"

if [ ! -d "$QUESTION_DIR" ]; then
  echo "Error: Question directory not found: $QUESTION_DIR"
  echo "Run with --list to see available questions."
  exit 1
fi

echo ""
echo "============================================="
echo " Running Lab Setup..."
echo "============================================="
if [ -f "$QUESTION_DIR/LabSetUp.bash" ]; then
  bash "$QUESTION_DIR/LabSetUp.bash"
else
  echo "No LabSetUp.bash found."
fi

echo ""
echo "============================================="
echo " Question:"
echo "============================================="
if [ -f "$QUESTION_DIR/Questions.bash" ]; then
  bash "$QUESTION_DIR/Questions.bash"
else
  echo "No Questions.bash found."
fi

echo ""
echo "============================================="
echo " When done, validate with:"
echo "   bash scripts/validate-rhcsa.sh <question_number>"
echo "============================================="
