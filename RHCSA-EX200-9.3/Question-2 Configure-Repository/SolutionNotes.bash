#!/bin/bash
cat <<'EOF'
╔══════════════════════════════════════════════════════════════════╗
║  SOLUTION — Q2: Configure the Repository                        ║
╠══════════════════════════════════════════════════════════════════╣

Step 1: Create the repo file
  vim /etc/yum.repos.d/local.repo

Step 2: Add the following content:

  [AppStream]
  name=AppStream
  baseurl=http://content.example.com/rhel9.3/x86_64/dvd/AppStream
  gpgcheck=0
  enabled=1

  [BaseOS]
  name=BaseOS
  baseurl=http://content.example.com/rhel9.3/x86_64/dvd/BaseOS
  gpgcheck=0
  enabled=1

Step 3: Verify
  dnf clean all
  dnf repolist
  # Should show both AppStream and BaseOS repos

╚══════════════════════════════════════════════════════════════════╝
EOF
