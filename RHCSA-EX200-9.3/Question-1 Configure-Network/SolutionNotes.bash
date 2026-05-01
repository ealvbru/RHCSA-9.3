#!/bin/bash
# Solution Notes for Question 1: Configure the Network

cat <<'EOF'
╔══════════════════════════════════════════════════════════════════╗
║  SOLUTION — Q1: Configure the Network                           ║
╠══════════════════════════════════════════════════════════════════╣

Step 1: Set the hostname
  hostnamectl set-hostname serverb.lab.example.com

Step 2: Identify the active connection name
  nmcli con show
  # Note the NAME of the active connection (e.g., "Wired connection 1"
  # or "ens160" or "eth0")

Step 3: Configure the network interface
  # Replace <CON_NAME> with your actual connection name
  nmcli con mod "<CON_NAME>" ipv4.addresses 172.25.250.11/24
  nmcli con mod "<CON_NAME>" ipv4.gateway 172.25.250.254
  nmcli con mod "<CON_NAME>" ipv4.dns 172.25.250.254
  nmcli con mod "<CON_NAME>" ipv4.method manual

Step 4: Bring the connection up
  nmcli con up "<CON_NAME>"

Step 5: Verify
  hostname                          # Should show serverb.lab.example.com
  ip addr show                      # Should show 172.25.250.11/24
  ip route show                     # Should show default via 172.25.250.254
  cat /etc/resolv.conf              # Should show nameserver 172.25.250.254

Step 6 (Optional): Enable PermitRootLogin for SSH
  vim /etc/ssh/sshd_config
  # Set: PermitRootLogin yes
  systemctl restart sshd

╚══════════════════════════════════════════════════════════════════╝
EOF
