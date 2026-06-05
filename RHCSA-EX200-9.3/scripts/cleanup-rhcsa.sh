#!/bin/bash
###############################################################################
#  RHCSA EX200 9.3 — Environment Cleanup Script
#  Reverts all changes made during the 22 exercises.
#
#  Usage:
#    bash cleanup-rhcsa.sh              # Clean ALL (serverb + servera)
#    bash cleanup-rhcsa.sh --serverb    # Clean only serverb tasks (Q1-Q18)
#    bash cleanup-rhcsa.sh --servera    # Clean only servera tasks (Q19-Q22)
#    bash cleanup-rhcsa.sh 1 3 5        # Clean specific questions only
#    bash cleanup-rhcsa.sh --dry-run    # Show what would be done (no changes)
#    bash cleanup-rhcsa.sh --force      # Skip confirmation prompts
#
#  IMPORTANT: Run as root on serverb. Servera cleanup uses SSH.
###############################################################################

set -o pipefail

# ─── Colors ──────────────────────────────────────────────────────────────────
RED='\033[0;31m'; GRN='\033[0;32m'; YLW='\033[1;33m'; CYN='\033[0;36m'
BLD='\033[1m'; RST='\033[0m'

DRY_RUN=false
FORCE=false
CLEANED=0
SKIPPED=0
ERRORS=0

# ─── Helper Functions ────────────────────────────────────────────────────────
info()  { echo -e "  ${CYN}[INFO]${RST}  $1"; }
ok()    { echo -e "  ${GRN}[DONE]${RST}  $1"; ((CLEANED++)); }
skip()  { echo -e "  ${YLW}[SKIP]${RST}  $1"; ((SKIPPED++)); }
err()   { echo -e "  ${RED}[ERR]${RST}   $1"; ((ERRORS++)); }

run() {
  # Execute a command, or just print it in dry-run mode
  if $DRY_RUN; then
    echo -e "  ${YLW}[DRY]${RST}   Would run: $*"
  else
    eval "$@" 2>/dev/null
  fi
}

section() {
  echo ""
  echo -e "  ${BLD}━━━ Q$1: $2 ━━━${RST}"
}

# ─── SSH helper for servera ──────────────────────────────────────────────────
SERVERA_SSH=""
setup_servera_ssh() {
  if [ -n "$SERVERA_SSH" ]; then return 0; fi
  # Try key-based first
  if ssh -o BatchMode=yes -o ConnectTimeout=3 root@servera.lab.example.com "echo ok" &>/dev/null; then
    SERVERA_SSH="ssh -o BatchMode=yes -o ConnectTimeout=3 root@servera.lab.example.com"
    return 0
  fi
  # Try password auth
  if command -v sshpass &>/dev/null; then
    if sshpass -p 'NorTh@te' ssh -o StrictHostKeyChecking=no -o ConnectTimeout=3 root@servera.lab.example.com "echo ok" &>/dev/null; then
      SERVERA_SSH="sshpass -p 'NorTh@te' ssh -o StrictHostKeyChecking=no -o ConnectTimeout=3 root@servera.lab.example.com"
      return 0
    fi
    if sshpass -p 'redhat' ssh -o StrictHostKeyChecking=no -o ConnectTimeout=3 root@servera.lab.example.com "echo ok" &>/dev/null; then
      SERVERA_SSH="sshpass -p 'redhat' ssh -o StrictHostKeyChecking=no -o ConnectTimeout=3 root@servera.lab.example.com"
      return 0
    fi
  fi
  err "Cannot SSH to servera — install sshpass or set up key-based auth"
  return 1
}

run_on_servera() {
  if $DRY_RUN; then
    echo -e "  ${YLW}[DRY]${RST}   Would run on servera: $*"
    return 0
  fi
  if [ -z "$SERVERA_SSH" ]; then
    setup_servera_ssh || return 1
  fi
  $SERVERA_SSH "$@" 2>/dev/null
}

###############################################################################
#  CLEANUP FUNCTIONS — SERVERB (Q1-Q18)
###############################################################################

cleanup_q1() {
  section 1 "Configure Network"
  # We do NOT reset the network — it would disconnect the session
  # Instead, we just inform the user
  skip "Network config (Q1) is NOT reverted — resetting IP would disconnect your session"
  info "To fully reset: use the lab environment reset function or manually reconfigure"
}

cleanup_q2() {
  section 2 "Configure Repository"
  # Remove user-created repo files
  local found=false
  for f in /etc/yum.repos.d/local.repo /etc/yum.repos.d/rhcsa.repo /etc/yum.repos.d/exam.repo /etc/yum.repos.d/myrepo.repo; do
    if [ -f "$f" ]; then
      run "rm -f '$f'"
      ok "Removed $f"
      found=true
    fi
  done
  # Also check for any user-created repos pointing to content.example.com
  for f in /etc/yum.repos.d/*.repo; do
    [ -f "$f" ] || continue
    if grep -q "content.example.com" "$f" 2>/dev/null; then
      local bn=$(basename "$f")
      # Don't remove system default repos
      case "$bn" in
        redhat.repo|rhel*.repo) continue ;;
      esac
      run "rm -f '$f'"
      ok "Removed $f (contained content.example.com)"
      found=true
    fi
  done
  $found || skip "No user-created repo files found"
  run "dnf clean all" && info "Cleaned dnf cache"
}

cleanup_q3() {
  section 3 "Create Users & Group"
  for user in harry natasha sarah; do
    if id "$user" &>/dev/null; then
      run "userdel -rf '$user'"
      ok "Removed user $user"
    else
      skip "User $user does not exist"
    fi
  done
  if getent group admin &>/dev/null; then
    run "groupdel admin"
    ok "Removed group admin"
  else
    skip "Group admin does not exist"
  fi
}

cleanup_q4() {
  section 4 "SELinux WebServer Port 82"
  # Stop and disable httpd
  if systemctl is-active httpd &>/dev/null; then
    run "systemctl stop httpd"
    ok "Stopped httpd"
  else
    skip "httpd is not running"
  fi
  if systemctl is-enabled httpd &>/dev/null; then
    run "systemctl disable httpd"
    ok "Disabled httpd"
  else
    skip "httpd is not enabled"
  fi
  # Restore httpd.conf to default port 80
  if [ -f /etc/httpd/conf/httpd.conf ]; then
    if grep -q "^Listen 82" /etc/httpd/conf/httpd.conf 2>/dev/null; then
      run "sed -i 's/^Listen 82/Listen 80/' /etc/httpd/conf/httpd.conf"
      ok "Restored httpd.conf to Listen 80"
    else
      skip "httpd.conf already on default port"
    fi
  fi
  # Remove SELinux port rule
  if semanage port -l 2>/dev/null | grep -q "http_port_t.*82"; then
    run "semanage port -d -t http_port_t -p tcp 82"
    ok "Removed SELinux port rule for 82/tcp"
  else
    skip "No SELinux port rule for 82/tcp"
  fi
  # Remove firewall rule
  if firewall-cmd --list-ports 2>/dev/null | grep -q "82/tcp"; then
    run "firewall-cmd --permanent --remove-port=82/tcp"
    run "firewall-cmd --reload"
    ok "Removed firewall rule for 82/tcp"
  else
    skip "No firewall rule for 82/tcp"
  fi
}

cleanup_q5() {
  section 5 "Shared Directory (SGID)"
  if [ -d /common ]; then
    run "rm -rf /common"
    ok "Removed /common directory"
  else
    skip "/common does not exist"
  fi
}

cleanup_q6() {
  section 6 "Automount NFS Home"
  # Stop and disable autofs
  if systemctl is-active autofs &>/dev/null; then
    run "systemctl stop autofs"
    ok "Stopped autofs"
  fi
  if systemctl is-enabled autofs &>/dev/null; then
    run "systemctl disable autofs"
    ok "Disabled autofs"
  fi
  # Remove auto.production map file
  if [ -f /etc/auto.production ]; then
    run "rm -f /etc/auto.production"
    ok "Removed /etc/auto.production"
  else
    skip "/etc/auto.production does not exist"
  fi
  # Remove the entry from auto.master
  if grep -q "localhome\|auto.production" /etc/auto.master 2>/dev/null; then
    run "sed -i '/localhome/d; /auto.production/d' /etc/auto.master"
    ok "Cleaned /etc/auto.master"
  else
    skip "No custom entries in /etc/auto.master"
  fi
  # Remove mount point
  if [ -d /localhome ]; then
    run "umount /localhome/production5 2>/dev/null; rm -rf /localhome"
    ok "Removed /localhome directory"
  else
    skip "/localhome does not exist"
  fi
  # Remove production5 user if created locally
  if id production5 &>/dev/null; then
    run "userdel -rf production5"
    ok "Removed local user production5"
  fi
}

cleanup_q7() {
  section 7 "Cron Job for harry"
  if crontab -l -u harry &>/dev/null 2>&1; then
    run "crontab -r -u harry"
    ok "Removed crontab for harry"
  else
    skip "No crontab for harry (user may not exist)"
  fi
}

cleanup_q8() {
  section 8 "Create User alies (UID 1326)"
  if id alies &>/dev/null; then
    run "userdel -rf alies"
    ok "Removed user alies"
  else
    skip "User alies does not exist"
  fi
}

cleanup_q9() {
  section 9 "Find Files by User"
  if [ -d /root/myfinds ]; then
    run "rm -rf /root/myfinds"
    ok "Removed /root/myfinds"
  else
    skip "/root/myfinds does not exist"
  fi
}

cleanup_q10() {
  section 10 "Tar Archive"
  local found=false
  for f in /root/test.tar.gz /root/test.tar.bz2; do
    if [ -f "$f" ]; then
      run "rm -f '$f'"
      ok "Removed $f"
      found=true
    fi
  done
  $found || skip "No tar archives found in /root"
  # Also clean up the test content created by LabSetUp
  if [ -d /var/tmp/rhcsa-archive ]; then
    run "rm -rf /var/tmp/rhcsa-archive"
    ok "Removed /var/tmp/rhcsa-archive"
  fi
}

cleanup_q11() {
  section 11 "Find String (grep)"
  if [ -f /root/search.txt ]; then
    run "rm -f /root/search.txt"
    ok "Removed /root/search.txt"
  else
    skip "/root/search.txt does not exist"
  fi
}

cleanup_q12() {
  section 12 "NTP Client (chrony)"
  # Remove the classroom.example.com line from chrony.conf
  if grep -q "classroom.example.com" /etc/chrony.conf 2>/dev/null; then
    run "sed -i '/classroom.example.com/d' /etc/chrony.conf"
    ok "Removed classroom.example.com from /etc/chrony.conf"
    if systemctl is-active chronyd &>/dev/null; then
      run "systemctl restart chronyd"
      info "Restarted chronyd"
    fi
  else
    skip "classroom.example.com not in chrony.conf"
  fi
}

cleanup_q13() {
  section 13 "Rootless Container Service"
  # This runs as user student
  local student_uid=$(id -u student 2>/dev/null)
  if [ -z "$student_uid" ]; then
    skip "User student does not exist — nothing to clean"
    return
  fi

  # Stop and disable the systemd user service
  if [ -f "/home/student/.config/systemd/user/container-ascii2pdf.service" ]; then
    run "su - student -c 'XDG_RUNTIME_DIR=/run/user/$student_uid systemctl --user stop container-ascii2pdf 2>/dev/null'"
    run "su - student -c 'XDG_RUNTIME_DIR=/run/user/$student_uid systemctl --user disable container-ascii2pdf 2>/dev/null'"
    run "rm -f /home/student/.config/systemd/user/container-ascii2pdf.service"
    ok "Removed systemd user service container-ascii2pdf"
  else
    skip "No container-ascii2pdf service found"
  fi

  # Remove the container
  if su - student -c "podman ps -a --format '{{.Names}}'" 2>/dev/null | grep -q "ascii2pdf"; then
    run "su - student -c 'podman rm -f ascii2pdf'"
    ok "Removed container ascii2pdf"
  else
    skip "Container ascii2pdf does not exist"
  fi

  # Remove pulled images
  if su - student -c "podman images --format '{{.Repository}}:{{.Tag}}'" 2>/dev/null | grep -q "admin034/monitor"; then
    run "su - student -c 'podman rmi -f docker.io/admin034/monitor:latest 2>/dev/null'"
    ok "Removed container image admin034/monitor"
  fi

  # Remove persistent volume directories
  for d in /opt/files /opt/processed; do
    if [ -d "$d" ]; then
      run "rm -rf '$d'"
      ok "Removed $d"
    fi
  done

  # Disable lingering
  if loginctl show-user student 2>/dev/null | grep -q "Linger=yes"; then
    run "loginctl disable-linger student"
    ok "Disabled lingering for student"
  else
    skip "Lingering not enabled for student"
  fi
}

cleanup_q14() {
  section 14 "Umask for natasha"
  # If natasha still exists, clean her .bashrc
  if id natasha &>/dev/null && [ -f /home/natasha/.bashrc ]; then
    if grep -q "umask" /home/natasha/.bashrc 2>/dev/null; then
      run "sed -i '/^umask/d' /home/natasha/.bashrc"
      ok "Removed umask from natasha's .bashrc"
    else
      skip "No umask in natasha's .bashrc"
    fi
  else
    skip "User natasha does not exist (cleaned by Q3)"
  fi
}

cleanup_q15() {
  section 15 "Password Expiry (20 days)"
  # Reset password expiry for users if they exist
  for user in harry natasha sarah alies; do
    if id "$user" &>/dev/null; then
      run "chage -M 99999 '$user'"
      ok "Reset password expiry for $user"
    fi
  done
  skip "Password expiry reset (or users already removed by Q3/Q8)"
}

cleanup_q16() {
  section 16 "Sudo for admin Group"
  # Remove sudoers files for admin group
  local found=false
  for f in /etc/sudoers.d/admin /etc/sudoers.d/admin_group /etc/sudoers.d/rhcsa-admin; do
    if [ -f "$f" ]; then
      run "rm -f '$f'"
      ok "Removed $f"
      found=true
    fi
  done
  # Also check for any file granting admin group sudo
  for f in /etc/sudoers.d/*; do
    [ -f "$f" ] || continue
    if grep -q "%admin" "$f" 2>/dev/null; then
      run "rm -f '$f'"
      ok "Removed $f (contained %admin)"
      found=true
    fi
  done
  $found || skip "No admin sudoers files found"
}

cleanup_q17() {
  section 17 "Login Message for alies"
  # Check /etc/motd
  if [ -s /etc/motd ]; then
    run "truncate -s 0 /etc/motd"
    ok "Cleared /etc/motd"
  else
    skip "/etc/motd is already empty"
  fi
  # Check user-specific .hushlogin or profile message
  if [ -f /home/alies/.bash_profile ]; then
    if grep -q "echo\|motd\|message" /home/alies/.bash_profile 2>/dev/null; then
      run "sed -i '/echo.*Welcome\|echo.*message/d' /home/alies/.bash_profile"
      ok "Cleaned alies .bash_profile"
    fi
  fi
}

cleanup_q18() {
  section 18 "Create Script mysearch"
  if [ -f /usr/local/bin/mysearch ]; then
    run "rm -f /usr/local/bin/mysearch"
    ok "Removed /usr/local/bin/mysearch"
  else
    skip "/usr/local/bin/mysearch does not exist"
  fi
  if [ -f /root/myfiles ]; then
    run "rm -f /root/myfiles"
    ok "Removed /root/myfiles"
  else
    skip "/root/myfiles does not exist"
  fi
}

###############################################################################
#  CLEANUP FUNCTIONS — SERVERA (Q19-Q22)
###############################################################################

cleanup_q19() {
  section 19 "Break Root Password (servera)"
  skip "Root password reset cannot be reverted automatically"
  info "The original root password was 'redhat' — reset manually if needed"
}

cleanup_q20() {
  section 20 "Swap Partition (servera)"
  if ! setup_servera_ssh; then
    err "Cannot connect to servera — skipping Q20 cleanup"
    return
  fi
  # Deactivate swap
  local swap_dev=$(run_on_servera "swapon --show --noheadings | grep vdb | awk '{print \$1}'" 2>/dev/null)
  if [ -n "$swap_dev" ]; then
    run_on_servera "swapoff $swap_dev"
    ok "Deactivated swap on $swap_dev"
  else
    skip "No swap on /dev/vdb found"
  fi
  # Remove fstab entry
  if run_on_servera "grep -q 'vdb.*swap\|swap.*vdb' /etc/fstab" 2>/dev/null; then
    run_on_servera "sed -i '/vdb.*swap/d; /swap.*vdb/d' /etc/fstab"
    ok "Removed swap entry from /etc/fstab on servera"
  else
    skip "No swap fstab entry on servera"
  fi
  # Delete partition (will be handled together with Q21)
  info "Partition cleanup will be done in Q21 cleanup (both partitions on /dev/vdb)"
}

cleanup_q21() {
  section 21 "Logical Volume (servera)"
  if ! setup_servera_ssh; then
    err "Cannot connect to servera — skipping Q21 cleanup"
    return
  fi
  # Unmount
  if run_on_servera "mountpoint -q /mnt/Software" 2>/dev/null; then
    run_on_servera "umount /mnt/Software"
    ok "Unmounted /mnt/Software"
  else
    skip "/mnt/Software is not mounted"
  fi
  # Remove fstab entry
  if run_on_servera "grep -q 'Developer\|/mnt/Software' /etc/fstab" 2>/dev/null; then
    run_on_servera "sed -i '/Developer/d; /mnt\/Software/d' /etc/fstab"
    ok "Removed LVM fstab entry on servera"
  fi
  # Remove LV
  if run_on_servera "lvs Developer/Engineer" &>/dev/null; then
    run_on_servera "lvremove -f /dev/Developer/Engineer"
    ok "Removed LV Engineer"
  else
    skip "LV Engineer does not exist"
  fi
  # Remove VG
  if run_on_servera "vgs Developer" &>/dev/null; then
    run_on_servera "vgremove -f Developer"
    ok "Removed VG Developer"
  else
    skip "VG Developer does not exist"
  fi
  # Remove PV
  if run_on_servera "pvs /dev/vdb2" &>/dev/null; then
    run_on_servera "pvremove -f /dev/vdb2"
    ok "Removed PV /dev/vdb2"
  else
    skip "PV /dev/vdb2 does not exist"
  fi
  # Remove mount point
  if run_on_servera "[ -d /mnt/Software ]" 2>/dev/null; then
    run_on_servera "rm -rf /mnt/Software"
    ok "Removed /mnt/Software directory"
  fi
  # Wipe partition table on /dev/vdb (cleans both Q20 swap and Q21 LVM)
  if run_on_servera "lsblk /dev/vdb" &>/dev/null; then
    run_on_servera "wipefs -a /dev/vdb 2>/dev/null; dd if=/dev/zero of=/dev/vdb bs=1M count=1 2>/dev/null; partprobe /dev/vdb 2>/dev/null"
    ok "Wiped partition table on /dev/vdb (servera)"
  else
    skip "/dev/vdb not found on servera"
  fi
}

cleanup_q22() {
  section 22 "Resize Logical Volume (servera)"
  skip "Already cleaned by Q21 (LV removal includes resized state)"
}

###############################################################################
#  MAIN
###############################################################################

# Parse arguments
QUESTIONS=()
while [[ $# -gt 0 ]]; do
  case "$1" in
    --dry-run)  DRY_RUN=true; shift ;;
    --force)    FORCE=true; shift ;;
    --serverb)  QUESTIONS=($(seq 1 18)); shift ;;
    --servera)  QUESTIONS=($(seq 19 22)); shift ;;
    --help|-h)
      echo "Usage: bash cleanup-rhcsa.sh [OPTIONS] [QUESTION_NUMBERS...]"
      echo ""
      echo "Options:"
      echo "  --dry-run     Show what would be done without making changes"
      echo "  --force       Skip confirmation prompts"
      echo "  --serverb     Clean only serverb tasks (Q1-Q18)"
      echo "  --servera     Clean only servera tasks (Q19-Q22)"
      echo "  --help        Show this help message"
      echo ""
      echo "Examples:"
      echo "  bash cleanup-rhcsa.sh              # Clean everything"
      echo "  bash cleanup-rhcsa.sh --dry-run    # Preview cleanup"
      echo "  bash cleanup-rhcsa.sh 3 5 8        # Clean Q3, Q5, Q8 only"
      echo "  bash cleanup-rhcsa.sh --serverb    # Clean all serverb tasks"
      exit 0
      ;;
    [0-9]*)     QUESTIONS+=("$1"); shift ;;
    *)          echo "Unknown option: $1"; exit 1 ;;
  esac
done

# Default: all questions
if [ ${#QUESTIONS[@]} -eq 0 ]; then
  QUESTIONS=($(seq 1 22))
fi

# Banner
echo ""
echo -e "  ${BLD}╔══════════════════════════════════════════════════════════════╗${RST}"
echo -e "  ${BLD}║     RHCSA EX200 9.3 — Environment Cleanup                  ║${RST}"
if $DRY_RUN; then
echo -e "  ${BLD}║     ${YLW}MODE: DRY RUN (no changes will be made)${RST}${BLD}                ║${RST}"
fi
echo -e "  ${BLD}╚══════════════════════════════════════════════════════════════╝${RST}"
echo ""
echo -e "  Questions to clean: ${BLD}${QUESTIONS[*]}${RST}"
echo -e "  Timestamp: $(date '+%Y-%m-%d %H:%M:%S')"

# Confirmation
if ! $FORCE && ! $DRY_RUN; then
  echo ""
  echo -e "  ${RED}WARNING: This will PERMANENTLY remove users, files, services,${RST}"
  echo -e "  ${RED}and configurations created during the exercises.${RST}"
  echo ""
  read -p "  Are you sure you want to continue? (yes/no): " confirm
  if [[ "$confirm" != "yes" && "$confirm" != "y" ]]; then
    echo -e "  ${YLW}Cleanup cancelled.${RST}"
    exit 0
  fi
fi

# Execute cleanup in dependency-safe order
# Q7 (cron for harry) before Q3 (delete harry)
# Q14 (umask for natasha) before Q3 (delete natasha)
# Q15 (password expiry) before Q3/Q8 (delete users)
# Q17 (login message for alies) before Q8 (delete alies)
# Q22 before Q21 (LV resize before LV removal)
# Q20 swap before Q21 wipes /dev/vdb

# Build ordered list based on dependencies
ORDERED_CLEANUP_ORDER=(7 14 15 17 1 2 4 5 6 9 10 11 12 16 18 13 3 8 19 22 20 21)

for q in "${ORDERED_CLEANUP_ORDER[@]}"; do
  # Check if this question was requested
  found=false
  for req in "${QUESTIONS[@]}"; do
    if [ "$req" -eq "$q" ] 2>/dev/null; then
      found=true
      break
    fi
  done
  $found || continue

  # Run the cleanup function
  case $q in
    1)  cleanup_q1  ;;
    2)  cleanup_q2  ;;
    3)  cleanup_q3  ;;
    4)  cleanup_q4  ;;
    5)  cleanup_q5  ;;
    6)  cleanup_q6  ;;
    7)  cleanup_q7  ;;
    8)  cleanup_q8  ;;
    9)  cleanup_q9  ;;
    10) cleanup_q10 ;;
    11) cleanup_q11 ;;
    12) cleanup_q12 ;;
    13) cleanup_q13 ;;
    14) cleanup_q14 ;;
    15) cleanup_q15 ;;
    16) cleanup_q16 ;;
    17) cleanup_q17 ;;
    18) cleanup_q18 ;;
    19) cleanup_q19 ;;
    20) cleanup_q20 ;;
    21) cleanup_q21 ;;
    22) cleanup_q22 ;;
  esac
done

# Summary
echo ""
echo -e "  ${BLD}═══════════════════════════════════════════════════════════════${RST}"
echo -e "  ${BLD}CLEANUP SUMMARY${RST}"
echo -e "  ${BLD}═══════════════════════════════════════════════════════════════${RST}"
echo -e "  ${GRN}Cleaned:${RST}  $CLEANED items"
echo -e "  ${YLW}Skipped:${RST}  $SKIPPED items (already clean or N/A)"
echo -e "  ${RED}Errors:${RST}   $ERRORS items"
echo ""
if $DRY_RUN; then
  echo -e "  ${YLW}This was a DRY RUN — no changes were made.${RST}"
  echo -e "  ${YLW}Run without --dry-run to apply changes.${RST}"
elif [ $ERRORS -eq 0 ]; then
  echo -e "  ${GRN}Environment cleanup completed successfully!${RST}"
  echo -e "  ${GRN}You can now re-run the exercises from scratch.${RST}"
else
  echo -e "  ${YLW}Cleanup completed with $ERRORS error(s).${RST}"
  echo -e "  ${YLW}Check the output above for details.${RST}"
fi
echo ""
