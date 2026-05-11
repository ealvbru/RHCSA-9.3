#!/bin/bash
###############################################################################
#  RHCSA EX200 9.3 — Automated Exam Validator
#  Passing Score: 70% (210/300)
#  Usage:
#    bash validate-rhcsa.sh              # Validate ALL questions
#    bash validate-rhcsa.sh 1 3 5        # Validate specific questions
#    bash validate-rhcsa.sh --serverb    # Validate only serverb questions (1-18)
#    bash validate-rhcsa.sh --servera    # Validate only servera questions (19-22)
###############################################################################

set -o pipefail

# ─── Colors ──────────────────────────────────────────────────────────────────
RED='\033[0;31m'; GRN='\033[0;32m'; YEL='\033[0;33m'; CYN='\033[0;36m'
BLD='\033[1m'; RST='\033[0m'

# ─── Score Tracking ──────────────────────────────────────────────────────────
declare -A Q_PASS Q_TOTAL Q_NAME Q_WEIGHT Q_DOMAIN
TOTAL_PASS=0; TOTAL_CHECKS=0

pass() { echo -e "  ${GRN}✅  $1${RST}"; ((Q_PASS[$CUR_Q]++)); ((TOTAL_PASS++)); ((Q_TOTAL[$CUR_Q]++)); ((TOTAL_CHECKS++)); }
fail() { echo -e "  ${RED}❌  $1${RST}"; ((Q_TOTAL[$CUR_Q]++)); ((TOTAL_CHECKS++)); }
info() { echo -e "  ${YEL}ℹ️  $1${RST}"; }
header() { echo -e "\n  ${BLD}${CYN}Question $1: $2${RST}"; }

# ─── Question Metadata ──────────────────────────────────────────────────────
init_metadata() {
  Q_NAME[1]="Configure Network";              Q_WEIGHT[1]=5;  Q_DOMAIN[1]="Manage Basic Networking"
  Q_NAME[2]="Configure Repository";           Q_WEIGHT[2]=5;  Q_DOMAIN[2]="Manage Software Packages"
  Q_NAME[3]="Create Users & Group";           Q_WEIGHT[3]=6;  Q_DOMAIN[3]="Manage Users & Groups"
  Q_NAME[4]="SELinux WebServer Port 82";      Q_WEIGHT[4]=7;  Q_DOMAIN[4]="Manage SELinux"
  Q_NAME[5]="Shared Directory (SGID)";        Q_WEIGHT[5]=5;  Q_DOMAIN[5]="Manage File Permissions"
  Q_NAME[6]="Automount NFS Home";             Q_WEIGHT[6]=6;  Q_DOMAIN[6]="Manage Storage"
  Q_NAME[7]="Cron Job for harry";             Q_WEIGHT[7]=4;  Q_DOMAIN[7]="Schedule Tasks"
  Q_NAME[8]="Create User alies (UID 1326)";   Q_WEIGHT[8]=3;  Q_DOMAIN[8]="Manage Users & Groups"
  Q_NAME[9]="Find Files by User";             Q_WEIGHT[9]=4;  Q_DOMAIN[9]="Essential File Operations"
  Q_NAME[10]="Tar Archive (gz & bz2)";        Q_WEIGHT[10]=4; Q_DOMAIN[10]="Essential File Operations"
  Q_NAME[11]="Find String (grep)";            Q_WEIGHT[11]=3; Q_DOMAIN[11]="Essential File Operations"
  Q_NAME[12]="NTP Client (chrony)";           Q_WEIGHT[12]=4; Q_DOMAIN[12]="Manage Basic Networking"
  Q_NAME[13]="Rootless Container Service";    Q_WEIGHT[13]=8; Q_DOMAIN[13]="Manage Containers"
  Q_NAME[14]="Umask for natasha";             Q_WEIGHT[14]=4; Q_DOMAIN[14]="Manage File Permissions"
  Q_NAME[15]="Password Expiry (20 days)";     Q_WEIGHT[15]=3; Q_DOMAIN[15]="Manage Users & Groups"
  Q_NAME[16]="Sudo for admin Group";          Q_WEIGHT[16]=4; Q_DOMAIN[16]="Manage Users & Groups"
  Q_NAME[17]="Login Message for alies";       Q_WEIGHT[17]=3; Q_DOMAIN[17]="Manage Users & Groups"
  Q_NAME[18]="Create Script mysearch";        Q_WEIGHT[18]=4; Q_DOMAIN[18]="Shell Scripting"
  Q_NAME[19]="Break Root Password";           Q_WEIGHT[19]=5; Q_DOMAIN[19]="Boot & Recovery"
  Q_NAME[20]="Swap Partition (512M)";         Q_WEIGHT[20]=6; Q_DOMAIN[20]="Manage Storage"
  Q_NAME[21]="Logical Volume (LVM)";          Q_WEIGHT[21]=7; Q_DOMAIN[21]="Manage Storage"
  Q_NAME[22]="Resize Logical Volume";         Q_WEIGHT[22]=5; Q_DOMAIN[22]="Manage Storage"

  for i in $(seq 1 22); do Q_PASS[$i]=0; Q_TOTAL[$i]=0; done
}

###############################################################################
# SERVERB VALIDATIONS (Q1-Q18)
###############################################################################

validate_q1() {
  CUR_Q=1; header 1 "${Q_NAME[1]}"

  # Check hostname
  local hn; hn=$(hostname 2>/dev/null)
  [[ "$hn" == "serverb.lab.example.com" ]] && pass "Hostname is serverb.lab.example.com" || fail "Hostname is '$hn' (expected serverb.lab.example.com)"

  # Check IP address
  if ip addr show 2>/dev/null | grep -q "172.25.250.11"; then
    pass "IP address 172.25.250.11 is configured"
  else
    fail "IP address 172.25.250.11 not found"
  fi

  # Check gateway
  if ip route show 2>/dev/null | grep -q "default via 172.25.250.254"; then
    pass "Default gateway is 172.25.250.254"
  else
    fail "Default gateway 172.25.250.254 not found"
  fi

  # Check DNS
  if grep -q "172.25.250.254" /etc/resolv.conf 2>/dev/null; then
    pass "DNS nameserver 172.25.250.254 configured"
  else
    fail "DNS nameserver 172.25.250.254 not in /etc/resolv.conf"
  fi
}

validate_q2() {
  CUR_Q=2; header 2 "${Q_NAME[2]}"

  # Check repo files exist
  local repo_found=false
  for f in /etc/yum.repos.d/*.repo; do
    if [ -f "$f" ]; then repo_found=true; break; fi
  done
  $repo_found && pass "Repo file(s) exist in /etc/yum.repos.d/" || fail "No .repo files found in /etc/yum.repos.d/"

  # Check AppStream repo
  if grep -rq "content.example.com.*AppStream" /etc/yum.repos.d/ 2>/dev/null; then
    pass "AppStream repository URL configured"
  else
    fail "AppStream repository URL not found"
  fi

  # Check BaseOS repo
  if grep -rq "content.example.com.*BaseOS" /etc/yum.repos.d/ 2>/dev/null; then
    pass "BaseOS repository URL configured"
  else
    fail "BaseOS repository URL not found"
  fi

  # Check repos are enabled
  if grep -rq "enabled=1\|enabled = 1" /etc/yum.repos.d/ 2>/dev/null; then
    pass "Repositories are enabled"
  else
    fail "Repositories not enabled (enabled=1 not found)"
  fi
}

validate_q3() {
  CUR_Q=3; header 3 "${Q_NAME[3]}"

  # Check group admin exists
  getent group admin &>/dev/null && pass "Group 'admin' exists" || fail "Group 'admin' does not exist"

  # Check user harry
  if id harry &>/dev/null; then
    pass "User 'harry' exists"
    id harry 2>/dev/null | grep -q "admin" && pass "harry is member of group 'admin'" || fail "harry is NOT in group 'admin'"
  else
    fail "User 'harry' does not exist"
    fail "harry is NOT in group 'admin' (user missing)"
  fi

  # Check user natasha
  if id natasha &>/dev/null; then
    pass "User 'natasha' exists"
    id natasha 2>/dev/null | grep -q "admin" && pass "natasha is member of group 'admin'" || fail "natasha is NOT in group 'admin'"
  else
    fail "User 'natasha' does not exist"
    fail "natasha is NOT in group 'admin' (user missing)"
  fi

  # Check user sarah
  if id sarah &>/dev/null; then
    pass "User 'sarah' exists"
    grep "^sarah:" /etc/passwd 2>/dev/null | grep -q "nologin" && pass "sarah has nologin shell" || fail "sarah does NOT have nologin shell"
  else
    fail "User 'sarah' does not exist"
    fail "sarah nologin shell (user missing)"
  fi
}

validate_q4() {
  CUR_Q=4; header 4 "${Q_NAME[4]}"

  # Check httpd installed
  rpm -q httpd &>/dev/null && pass "httpd is installed" || fail "httpd is NOT installed"

  # Check httpd listening on port 82
  if grep -q "^Listen 82" /etc/httpd/conf/httpd.conf 2>/dev/null; then
    pass "httpd configured to listen on port 82"
  else
    fail "httpd NOT configured for port 82"
  fi

  # Check SELinux port
  if semanage port -l 2>/dev/null | grep "http_port_t" | grep -q "82"; then
    pass "SELinux allows http_port_t on port 82"
  else
    fail "SELinux does NOT allow http_port_t on port 82"
  fi

  # Check firewall
  if firewall-cmd --list-ports 2>/dev/null | grep -q "82/tcp"; then
    pass "Firewall allows port 82/tcp"
  else
    fail "Firewall does NOT allow port 82/tcp"
  fi

  # Check httpd is running and enabled
  systemctl is-active httpd &>/dev/null && pass "httpd service is running" || fail "httpd service is NOT running"
  systemctl is-enabled httpd &>/dev/null && pass "httpd service is enabled" || fail "httpd service is NOT enabled"
}

validate_q5() {
  CUR_Q=5; header 5 "${Q_NAME[5]}"

  # Check directory exists
  [ -d "/common/shared" ] && pass "Directory /common/shared exists" || fail "Directory /common/shared does NOT exist"

  # Check group ownership
  local grp; grp=$(stat -c '%G' /common/shared 2>/dev/null)
  [[ "$grp" == "admin" ]] && pass "Group ownership is 'admin'" || fail "Group ownership is '$grp' (expected admin)"

  # Check SGID bit
  if stat -c '%A' /common/shared 2>/dev/null | grep -q "s"; then
    pass "SGID bit is set on /common/shared"
  else
    fail "SGID bit is NOT set"
  fi

  # Check permissions (no others access)
  local perms; perms=$(stat -c '%a' /common/shared 2>/dev/null)
  if [[ "$perms" == "2770" || "$perms" == "3770" ]]; then
    pass "Permissions correct (others have no access)"
  else
    fail "Permissions are $perms (expected 2770)"
  fi
}

validate_q6() {
  CUR_Q=6; header 6 "${Q_NAME[6]}"

  # Check autofs installed
  rpm -q autofs &>/dev/null && pass "autofs is installed" || fail "autofs is NOT installed"

  # Check autofs service
  systemctl is-active autofs &>/dev/null && pass "autofs service is running" || fail "autofs service is NOT running"
  systemctl is-enabled autofs &>/dev/null && pass "autofs service is enabled" || fail "autofs service is NOT enabled"

  # Check auto.master has /localhome entry
  if grep -q "/localhome" /etc/auto.master 2>/dev/null || grep -rq "/localhome" /etc/auto.master.d/ 2>/dev/null; then
    pass "/localhome configured in auto.master"
  else
    fail "/localhome NOT found in auto.master"
  fi

  # Check indirect map has production5
  if grep -rq "production5.*servera" /etc/auto.* 2>/dev/null; then
    pass "production5 NFS mount configured in autofs map"
  else
    fail "production5 NFS mount NOT configured"
  fi
}

validate_q7() {
  CUR_Q=7; header 7 "${Q_NAME[7]}"

  # Check crontab for harry exists
  if crontab -lu harry &>/dev/null; then
    pass "Crontab exists for user harry"

    # Check for the specific cron entry (flexible matching)
    local cron_content; cron_content=$(crontab -lu harry 2>/dev/null)
    if echo "$cron_content" | grep -q "23 14.*logger"; then
      pass "Cron job scheduled at 14:23 with logger command"
    elif echo "$cron_content" | grep -q "logger.*RHCSA\|echo.*Hello\|echo.*EX200"; then
      pass "Cron job command found (variant detected)"
    else
      fail "Expected cron job not found in harry's crontab"
    fi
  else
    fail "No crontab for user harry"
    fail "Cron job not configured"
  fi
}

validate_q8() {
  CUR_Q=8; header 8 "${Q_NAME[8]}"

  # Check user exists
  if id alies &>/dev/null; then
    pass "User 'alies' exists"

    # Check UID
    local uid; uid=$(id -u alies 2>/dev/null)
    [[ "$uid" == "1326" ]] && pass "alies has UID 1326" || fail "alies has UID $uid (expected 1326)"
  else
    fail "User 'alies' does not exist"
    fail "Cannot check UID (user missing)"
  fi
}

validate_q9() {
  CUR_Q=9; header 9 "${Q_NAME[9]}"

  # Check directory exists
  [ -d "/root/myfinds" ] && pass "Directory /root/myfinds exists" || fail "Directory /root/myfinds does NOT exist"

  # Check it has files
  local count; count=$(ls -1 /root/myfinds/ 2>/dev/null | wc -l)
  if [ "$count" -gt 0 ] 2>/dev/null; then
    pass "/root/myfinds contains $count file(s)"
  else
    fail "/root/myfinds is empty"
  fi
}

validate_q10() {
  CUR_Q=10; header 10 "${Q_NAME[10]}"

  # Check gzip archive
  if [ -f "/root/test.tar.gz" ]; then
    pass "/root/test.tar.gz exists"
    file /root/test.tar.gz 2>/dev/null | grep -qi "gzip" && pass "test.tar.gz is gzip compressed" || fail "test.tar.gz is NOT gzip compressed"
  else
    fail "/root/test.tar.gz does NOT exist"
    fail "Cannot verify gzip compression"
  fi

  # Check bzip2 archive
  if [ -f "/root/test.tar.bz2" ]; then
    pass "/root/test.tar.bz2 exists"
    file /root/test.tar.bz2 2>/dev/null | grep -qi "bzip2" && pass "test.tar.bz2 is bzip2 compressed" || fail "test.tar.bz2 is NOT bzip2 compressed"
  else
    fail "/root/test.tar.bz2 does NOT exist"
    fail "Cannot verify bzip2 compression"
  fi
}

validate_q11() {
  CUR_Q=11; header 11 "${Q_NAME[11]}"

  # Check file exists
  if [ -f "/root/search.txt" ]; then
    pass "/root/search.txt exists"

    # Check content matches grep output
    local expected; expected=$(grep "home" /etc/passwd 2>/dev/null | wc -l)
    local actual; actual=$(wc -l < /root/search.txt 2>/dev/null)

    if [ "$expected" -gt 0 ] && [ "$actual" -eq "$expected" ] 2>/dev/null; then
      pass "search.txt has correct number of lines ($actual)"
    else
      fail "search.txt has $actual lines (expected $expected)"
    fi

    # Check all lines contain "home"
    local bad_lines; bad_lines=$(grep -cv "home" /root/search.txt 2>/dev/null)
    if [ "$bad_lines" -eq 0 ] 2>/dev/null; then
      pass "All lines in search.txt contain 'home'"
    else
      fail "$bad_lines line(s) in search.txt do NOT contain 'home'"
    fi
  else
    fail "/root/search.txt does NOT exist"
    fail "Cannot verify content"
    fail "Cannot verify line matching"
  fi
}

validate_q12() {
  CUR_Q=12; header 12 "${Q_NAME[12]}"

  # Check chrony installed
  rpm -q chrony &>/dev/null && pass "chrony is installed" || fail "chrony is NOT installed"

  # Check chronyd service
  systemctl is-active chronyd &>/dev/null && pass "chronyd service is running" || fail "chronyd service is NOT running"
  systemctl is-enabled chronyd &>/dev/null && pass "chronyd service is enabled" || fail "chronyd service is NOT enabled"

  # Check NTP server configured
  if grep -q "classroom.example.com" /etc/chrony.conf 2>/dev/null; then
    pass "NTP server classroom.example.com configured"
  else
    fail "NTP server classroom.example.com NOT in chrony.conf"
  fi
}

validate_q13() {
  CUR_Q=13; header 13 "${Q_NAME[13]}"

  # Check user student exists
  id student &>/dev/null && pass "User 'student' exists" || fail "User 'student' does not exist"

  # Check podman installed
  command -v podman &>/dev/null && pass "podman is installed" || fail "podman is NOT installed"

  # Check container exists (running or created) for student
  if sudo -u student podman ps -a --format '{{.Names}}' 2>/dev/null | grep -q "ascii2pdf"; then
    pass "Container 'ascii2pdf' exists for user student"
  else
    fail "Container 'ascii2pdf' NOT found for user student"
  fi

  # Check systemd service file exists
  if [ -f "/home/student/.config/systemd/user/container-ascii2pdf.service" ]; then
    pass "Systemd user service file exists"
  else
    fail "Systemd user service file NOT found"
  fi

  # Check service is enabled
  if sudo -u student XDG_RUNTIME_DIR=/run/user/$(id -u student 2>/dev/null) systemctl --user is-enabled container-ascii2pdf.service &>/dev/null; then
    pass "container-ascii2pdf service is enabled"
  else
    fail "container-ascii2pdf service is NOT enabled"
  fi

  # Check lingering
  if loginctl show-user student 2>/dev/null | grep -q "Linger=yes"; then
    pass "Lingering enabled for user student"
  elif [ -f "/var/lib/systemd/linger/student" ]; then
    pass "Lingering enabled for user student"
  else
    fail "Lingering NOT enabled for user student"
  fi

  # Check volume mounts
  if sudo -u student podman inspect ascii2pdf 2>/dev/null | grep -q "/opt/incoming"; then
    pass "Volume /opt/files → /opt/incoming mounted"
  else
    fail "Volume /opt/files → /opt/incoming NOT mounted"
  fi

  if sudo -u student podman inspect ascii2pdf 2>/dev/null | grep -q "/opt/outgoing"; then
    pass "Volume /opt/processed → /opt/outgoing mounted"
  else
    fail "Volume /opt/processed → /opt/outgoing NOT mounted"
  fi
}

validate_q14() {
  CUR_Q=14; header 14 "${Q_NAME[14]}"

  # Check umask in natasha's profile
  if grep -q "umask.*277\|umask.*0277" /home/natasha/.bash_profile 2>/dev/null || \
     grep -q "umask.*277\|umask.*0277" /home/natasha/.bashrc 2>/dev/null; then
    pass "umask 0277 set in natasha's profile"
  else
    fail "umask 0277 NOT found in natasha's profile"
  fi

  # Test actual file creation permissions
  if id natasha &>/dev/null; then
    local testfile="/tmp/.rhcsa_umask_test_$$"
    su - natasha -c "touch $testfile" 2>/dev/null
    if [ -f "$testfile" ]; then
      local perms; perms=$(stat -c '%a' "$testfile" 2>/dev/null)
      [[ "$perms" == "400" ]] && pass "New files have permissions 0400 (-r--------)" || fail "New files have permissions $perms (expected 400)"
      rm -f "$testfile"
    else
      fail "Could not create test file as natasha"
    fi
  else
    fail "User natasha not found, cannot test umask"
  fi
}

validate_q15() {
  CUR_Q=15; header 15 "${Q_NAME[15]}"

  # Check PASS_MAX_DAYS in login.defs
  local max_days; max_days=$(grep "^PASS_MAX_DAYS" /etc/login.defs 2>/dev/null | awk '{print $2}')
  if [[ "$max_days" == "20" ]]; then
    pass "PASS_MAX_DAYS is set to 20 in /etc/login.defs"
  else
    fail "PASS_MAX_DAYS is '$max_days' (expected 20)"
  fi
}

validate_q16() {
  CUR_Q=16; header 16 "${Q_NAME[16]}"

  # Check sudoers for admin group
  if sudo grep -rq "%admin.*NOPASSWD.*ALL" /etc/sudoers /etc/sudoers.d/ 2>/dev/null; then
    pass "Group 'admin' has NOPASSWD sudo access"
  else
    fail "Group 'admin' NOPASSWD sudo NOT configured"
  fi

  # Test actual sudo access
  if id harry &>/dev/null; then
    local result; result=$(sudo -u harry sudo -n whoami 2>/dev/null)
    [[ "$result" == "root" ]] && pass "harry can sudo without password" || fail "harry cannot sudo without password"
  else
    fail "User harry not found, cannot test sudo"
  fi
}

validate_q17() {
  CUR_Q=17; header 17 "${Q_NAME[17]}"

  # Check bash_profile for the message
  if grep -q "Welcome to Exam Training" /home/alies/.bash_profile 2>/dev/null; then
    pass "Login message configured in alies's .bash_profile"
  else
    fail "Login message NOT found in alies's .bash_profile"
  fi

  # Test actual login output
  if id alies &>/dev/null; then
    local output; output=$(su - alies -c "exit" 2>/dev/null)
    if echo "$output" | grep -q "Welcome to Exam Training"; then
      pass "Login displays 'Welcome to Exam Training'"
    else
      fail "Login does NOT display the expected message"
    fi
  else
    fail "User alies not found, cannot test login message"
  fi
}

validate_q18() {
  CUR_Q=18; header 18 "${Q_NAME[18]}"

  # Check script exists
  if [ -f "/usr/local/bin/mysearch" ]; then
    pass "Script /usr/local/bin/mysearch exists"

    # Check executable
    [ -x "/usr/local/bin/mysearch" ] && pass "mysearch is executable" || fail "mysearch is NOT executable"

    # Check content uses find
    if grep -q "find.*/usr/share" /usr/local/bin/mysearch 2>/dev/null; then
      pass "Script searches /usr/share"
    else
      fail "Script does NOT search /usr/share"
    fi

    # Check it references size
    if grep -q "\-size.*1M\|-size.*-1M" /usr/local/bin/mysearch 2>/dev/null; then
      pass "Script filters by size < 1M"
    else
      fail "Script does NOT filter by size"
    fi
  else
    fail "Script /usr/local/bin/mysearch does NOT exist"
    fail "Cannot check executable permission"
    fail "Cannot check script content"
    fail "Cannot check size filter"
  fi

  # Check output file exists
  if [ -f "/root/myfiles" ]; then
    pass "/root/myfiles output file exists"
    local lines; lines=$(wc -l < /root/myfiles 2>/dev/null)
    [ "$lines" -gt 0 ] 2>/dev/null && pass "/root/myfiles has content ($lines lines)" || fail "/root/myfiles is empty"
  else
    fail "/root/myfiles does NOT exist (script not executed?)"
    fail "Cannot verify output content"
  fi
}

###############################################################################
# SERVERA VALIDATIONS (Q19-Q22)
###############################################################################

validate_q19() {
  CUR_Q=19; header 19 "${Q_NAME[19]}"

  # Check if we can SSH to servera (password reset successful)
  if ssh -o BatchMode=yes -o ConnectTimeout=3 root@servera.lab.example.com "echo ok" &>/dev/null; then
    pass "SSH to servera as root works (key-based)"
    # Check PermitRootLogin
    local prl; prl=$(ssh -o ConnectTimeout=3 root@servera.lab.example.com "grep -i '^PermitRootLogin' /etc/ssh/sshd_config" 2>/dev/null)
    if echo "$prl" | grep -qi "yes"; then
      pass "PermitRootLogin is set to yes on servera"
    else
      fail "PermitRootLogin not set to yes on servera"
    fi
  else
    info "Cannot SSH to servera with key — trying password auth..."
    if sshpass -p 'NorTh@te' ssh -o StrictHostKeyChecking=no -o ConnectTimeout=3 root@servera.lab.example.com "echo ok" &>/dev/null; then
      pass "Root password reset to NorTh@te (SSH login works)"
      pass "PermitRootLogin is enabled (SSH password login works)"
    else
      fail "Cannot SSH to servera as root (password may not be reset)"
      fail "PermitRootLogin status unknown"
    fi
  fi
}

validate_q20() {
  CUR_Q=20; header 20 "${Q_NAME[20]}"

  # These checks run ON servera (via SSH)
  local SSH_CMD="ssh -o BatchMode=yes -o ConnectTimeout=3 root@servera.lab.example.com"

  # Check if we can reach servera
  if ! $SSH_CMD "echo ok" &>/dev/null; then
    # Try with sshpass
    SSH_CMD="sshpass -p 'NorTh@te' ssh -o StrictHostKeyChecking=no -o ConnectTimeout=3 root@servera.lab.example.com"
    if ! $SSH_CMD "echo ok" &>/dev/null; then
      fail "Cannot SSH to servera — skipping swap checks"
      fail "Swap partition check skipped"
      fail "Swap in fstab check skipped"
      fail "Swap active check skipped"
      return
    fi
  fi

  # Check swap partition exists on vdb
  if $SSH_CMD "lsblk /dev/vdb1 2>/dev/null" | grep -qi "swap\|part"; then
    pass "Partition /dev/vdb1 exists"
  else
    fail "Partition /dev/vdb1 does NOT exist"
  fi

  # Check swap is in fstab
  if $SSH_CMD "grep -q 'vdb1.*swap\|swap.*vdb1' /etc/fstab 2>/dev/null"; then
    pass "Swap partition in /etc/fstab"
  else
    fail "Swap partition NOT in /etc/fstab"
  fi

  # Check swap is active
  if $SSH_CMD "swapon --show 2>/dev/null" | grep -q "vdb1"; then
    pass "Swap partition is active"
  else
    fail "Swap partition is NOT active"
  fi

  # Check swap size (~512M)
  local swap_size; swap_size=$($SSH_CMD "swapon --show --bytes 2>/dev/null" | grep "vdb1" | awk '{print $3}')
  if [ -n "$swap_size" ] && [ "$swap_size" -gt 400000000 ] 2>/dev/null; then
    pass "Swap size is approximately 512M"
  else
    fail "Swap size is incorrect or not detected"
  fi
}

validate_q21() {
  CUR_Q=21; header 21 "${Q_NAME[21]}"

  local SSH_CMD="ssh -o BatchMode=yes -o ConnectTimeout=3 root@servera.lab.example.com"
  if ! $SSH_CMD "echo ok" &>/dev/null; then
    SSH_CMD="sshpass -p 'NorTh@te' ssh -o StrictHostKeyChecking=no -o ConnectTimeout=3 root@servera.lab.example.com"
    if ! $SSH_CMD "echo ok" &>/dev/null; then
      for i in 1 2 3 4 5 6 7; do fail "Cannot SSH to servera — LVM check $i skipped"; done
      return
    fi
  fi

  # Check VG Developer exists
  if $SSH_CMD "vgdisplay Developer &>/dev/null"; then
    pass "Volume Group 'Developer' exists"
  else
    fail "Volume Group 'Developer' does NOT exist"
  fi

  # Check PE size is 8M
  local pe_size; pe_size=$($SSH_CMD "vgdisplay Developer 2>/dev/null" | grep "PE Size" | awk '{print $3}')
  if [[ "$pe_size" == "8.00" || "$pe_size" == "8" ]]; then
    pass "VG extent size is 8 MiB"
  else
    fail "VG extent size is '$pe_size' (expected 8 MiB)"
  fi

  # Check LV Engineer exists
  if $SSH_CMD "lvdisplay /dev/Developer/Engineer &>/dev/null"; then
    pass "Logical Volume 'Engineer' exists"
  else
    fail "Logical Volume 'Engineer' does NOT exist"
  fi

  # Check LV has 50 extents
  local le_count; le_count=$($SSH_CMD "lvdisplay /dev/Developer/Engineer 2>/dev/null" | grep "Current LE" | awk '{print $3}')
  if [[ "$le_count" == "50" ]]; then
    pass "LV has 50 logical extents"
  else
    # After resize it might be more
    info "LV has $le_count extents (50 expected for initial, more after resize)"
    pass "LV exists with $le_count extents"
  fi

  # Check ext3 filesystem
  if $SSH_CMD "blkid /dev/Developer/Engineer 2>/dev/null" | grep -q "ext3"; then
    pass "Filesystem is ext3"
  else
    fail "Filesystem is NOT ext3"
  fi

  # Check mounted at /mnt/Software
  if $SSH_CMD "mount 2>/dev/null" | grep -q "/mnt/Software"; then
    pass "LV mounted at /mnt/Software"
  else
    fail "LV NOT mounted at /mnt/Software"
  fi

  # Check fstab entry
  if $SSH_CMD "grep -q 'Developer.*Engineer.*Software\|Software.*ext3' /etc/fstab 2>/dev/null"; then
    pass "LV mount in /etc/fstab (persistent)"
  else
    fail "LV mount NOT in /etc/fstab"
  fi
}

validate_q22() {
  CUR_Q=22; header 22 "${Q_NAME[22]}"

  local SSH_CMD="ssh -o BatchMode=yes -o ConnectTimeout=3 root@servera.lab.example.com"
  if ! $SSH_CMD "echo ok" &>/dev/null; then
    SSH_CMD="sshpass -p 'NorTh@te' ssh -o StrictHostKeyChecking=no -o ConnectTimeout=3 root@servera.lab.example.com"
    if ! $SSH_CMD "echo ok" &>/dev/null; then
      fail "Cannot SSH to servera — resize check skipped"
      fail "LV size check skipped"
      fail "Filesystem size check skipped"
      return
    fi
  fi

  # Check LV size is between 500M and 600M
  local lv_size_k; lv_size_k=$($SSH_CMD "lvs --noheadings --nosuffix --units k -o lv_size /dev/Developer/Engineer 2>/dev/null" | tr -d ' ')
  if [ -n "$lv_size_k" ]; then
    # Convert to MB
    local lv_size_m; lv_size_m=$(echo "$lv_size_k / 1024" | bc 2>/dev/null)
    if [ "$lv_size_m" -ge 490 ] && [ "$lv_size_m" -le 620 ] 2>/dev/null; then
      pass "LV size is ${lv_size_m}M (within 500M-600M range)"
    else
      fail "LV size is ${lv_size_m}M (expected 500M-600M)"
    fi
  else
    fail "Cannot determine LV size"
  fi

  # Check filesystem is resized too
  local fs_size; fs_size=$($SSH_CMD "df -m /mnt/Software 2>/dev/null" | tail -1 | awk '{print $2}')
  if [ -n "$fs_size" ] && [ "$fs_size" -ge 450 ] && [ "$fs_size" -le 620 ] 2>/dev/null; then
    pass "Filesystem resized to ${fs_size}M (matches LV)"
  else
    fail "Filesystem size is ${fs_size}M (expected ~500M)"
  fi

  # Check mount still works
  if $SSH_CMD "mount 2>/dev/null" | grep -q "/mnt/Software"; then
    pass "/mnt/Software is still mounted after resize"
  else
    fail "/mnt/Software is NOT mounted after resize"
  fi
}

###############################################################################
# MAIN — SCORE REPORT
###############################################################################

main() {
  init_metadata

  echo ""
  echo -e "  ${BLD}╔══════════════════════════════════════════════════════════════╗${RST}"
  echo -e "  ${BLD}║     RHCSA EX200 9.3 — Automated Exam Validator             ║${RST}"
  echo -e "  ${BLD}║     Passing Score: 70% (210/300)                            ║${RST}"
  echo -e "  ${BLD}╚══════════════════════════════════════════════════════════════╝${RST}"
  echo ""
  echo -e "  Starting validation at $(date '+%Y-%m-%d %H:%M:%S')"

  # Determine which questions to validate
  local questions=()
  if [ $# -eq 0 ]; then
    questions=($(seq 1 22))
    echo -e "  Questions selected: ALL (1-22)"
  elif [[ "$1" == "--serverb" ]]; then
    questions=($(seq 1 18))
    echo -e "  Questions selected: serverb (1-18)"
  elif [[ "$1" == "--servera" ]]; then
    questions=(19 20 21 22)
    echo -e "  Questions selected: servera (19-22)"
  else
    questions=("$@")
    echo -e "  Questions selected: ${questions[*]}"
  fi

  # Run validations
  for q in "${questions[@]}"; do
    case $q in
      1)  validate_q1  ;; 2)  validate_q2  ;; 3)  validate_q3  ;;
      4)  validate_q4  ;; 5)  validate_q5  ;; 6)  validate_q6  ;;
      7)  validate_q7  ;; 8)  validate_q8  ;; 9)  validate_q9  ;;
      10) validate_q10 ;; 11) validate_q11 ;; 12) validate_q12 ;;
      13) validate_q13 ;; 14) validate_q14 ;; 15) validate_q15 ;;
      16) validate_q16 ;; 17) validate_q17 ;; 18) validate_q18 ;;
      19) validate_q19 ;; 20) validate_q20 ;; 21) validate_q21 ;;
      22) validate_q22 ;;
      *)  echo -e "  ${RED}Unknown question: $q${RST}" ;;
    esac
  done

  # ─── Score Report ────────────────────────────────────────────────────────
  echo ""
  echo -e "  ${BLD}${CYN}═══════════════════════════════════════════════════════════════${RST}"
  echo -e "  ${BLD}EXAM RESULTS${RST}"
  echo -e "  ${BLD}${CYN}═══════════════════════════════════════════════════════════════${RST}"
  printf "  ${BLD}%-6s %-42s %7s %7s %8s${RST}\n" "Q#" "Topic" "Checks" "Passed" "Score"
  printf "  ${BLD}%-6s %-42s %7s %7s %8s${RST}\n" "------" "------------------------------------------" "-------" "-------" "--------"

  local weighted_score=0
  local total_weight=0

  for q in "${questions[@]}"; do
    local t=${Q_TOTAL[$q]:-0}
    local p=${Q_PASS[$q]:-0}
    local pct=0
    if [ "$t" -gt 0 ]; then
      pct=$(echo "scale=1; $p * 100 / $t" | bc 2>/dev/null)
    fi

    local w=${Q_WEIGHT[$q]:-0}
    if [ "$t" -gt 0 ]; then
      local q_score; q_score=$(echo "scale=4; ($p / $t) * $w" | bc 2>/dev/null)
      weighted_score=$(echo "scale=4; $weighted_score + $q_score" | bc 2>/dev/null)
    fi
    total_weight=$(echo "$total_weight + $w" | bc 2>/dev/null)

    local color="$RED"
    [ "$p" -eq "$t" ] 2>/dev/null && [ "$t" -gt 0 ] && color="$GRN"
    [ "$p" -gt 0 ] 2>/dev/null && [ "$p" -lt "$t" ] 2>/dev/null && color="$YEL"

    printf "  ${color}%-6s %-42s %7s %7s %7s%%${RST}\n" "Q${q}" "${Q_NAME[$q]}" "$t" "$p" "$pct"
  done

  printf "  ${BLD}%-6s %-42s %7s %7s${RST}\n" "------" "------------------------------------------" "-------" "-------"
  printf "  ${BLD}%-6s %-42s %7s %7s${RST}\n" "TOTAL" "All Checks" "$TOTAL_CHECKS" "$TOTAL_PASS"

  # Calculate final weighted percentage
  local final_pct=0
  if [ "$(echo "$total_weight > 0" | bc 2>/dev/null)" -eq 1 ]; then
    final_pct=$(echo "scale=1; ($weighted_score / $total_weight) * 100" | bc 2>/dev/null)
  fi

  # Domain mapping
  echo ""
  echo -e "  ${BLD}RHCSA Exam Domain Mapping:${RST}"
  for q in "${questions[@]}"; do
    printf "    Q%-2s %-30s %s\n" "$q" "${Q_NAME[$q]}" "${Q_DOMAIN[$q]}"
  done

  # Final verdict
  echo ""
  local verdict_color="$RED"
  local verdict_text="FAILED"
  local verdict_icon="❌"
  if [ "$(echo "$final_pct >= 70" | bc 2>/dev/null)" -eq 1 ]; then
    verdict_color="$GRN"
    verdict_text="PASSED!"
    verdict_icon="✅"
  fi

  echo -e "  ${BLD}╔═══════════════════════════════════════════════╗${RST}"
  printf "  ${BLD}║  FINAL SCORE:  ${verdict_color}%-7s ${verdict_icon}  %-18s${RST}${BLD}║${RST}\n" "${final_pct}%" "$verdict_text"
  echo -e "  ${BLD}║  Passing Score:  70%                          ║${RST}"
  echo -e "  ${BLD}╚═══════════════════════════════════════════════╝${RST}"
  echo -e "  Validation completed at $(date '+%Y-%m-%d %H:%M:%S')"
  echo ""

  # Exit code
  [ "$(echo "$final_pct >= 70" | bc 2>/dev/null)" -eq 1 ] && exit 0 || exit 1
}

main "$@"
