#!/bin/bash
# RHCSA EX200 9.3 — Question 2: Configure the Repository
# Domain: Manage Software Packages
# Weight: 5%

cat <<'EOF'
╔══════════════════════════════════════════════════════════════════╗
║  QUESTION 2 — Configure the Repository (serverb)               ║
╠══════════════════════════════════════════════════════════════════╣
║                                                                  ║
║  Configure your system to use the following YUM/DNF             ║
║  repositories:                                                   ║
║                                                                  ║
║  Repository 1 — AppStream:                                      ║
║    URL: http://classroom.example.com/content/rhel9.3/x86_64/   ║
║         dvd/AppStream                                            ║
║                                                                  ║
║  Repository 2 — BaseOS:                                         ║
║    URL: http://classroom.example.com/content/rhel9.3/x86_64/   ║
║         dvd/BaseOS                                               ║
║                                                                  ║
║  Requirements:                                                   ║
║  a) Both repositories must be enabled                           ║
║  b) GPG check is not required                                   ║
║  c) Verify with: dnf repolist                                   ║
║                                                                  ║
╚══════════════════════════════════════════════════════════════════╝
EOF
