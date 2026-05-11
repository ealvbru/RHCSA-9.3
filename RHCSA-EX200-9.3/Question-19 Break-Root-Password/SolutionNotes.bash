#!/bin/bash
cat <<'EOF'
╔══════════════════════════════════════════════════════════════════╗
║  SOLUTION — Q19: Break/Reset the Root Password                  ║
╠══════════════════════════════════════════════════════════════════╣

Step 1: Access the GRUB menu
  - Reboot servera (Ctrl+Alt+Del or reboot command)
  - When GRUB menu appears, press DOWN ARROW to stop the timer
  - Press 'e' to edit the selected boot entry

Step 2: Add rd.break to the kernel line
  - Navigate to the line starting with "linux"
  - Press END to go to the end of that line
  - Add a space and type: rd.break
  - Press Ctrl+X to boot with the modified parameters

Step 3: In the emergency shell
  mount -o remount,rw /sysroot
  chroot /sysroot

Step 4: Reset the root password
  echo "NorTh@te" | passwd --stdin root

Step 5: Create autorelabel file (for SELinux)
  touch /.autorelabel

Step 6: Enable SSH root login
  vim /etc/ssh/sshd_config
  # Set: PermitRootLogin yes

Step 7: Exit and reboot
  exit        # Exit chroot
  exit        # Exit emergency shell (triggers reboot)

Step 8: Wait for SELinux relabeling to complete, then verify
  ssh root@servera.lab.example.com
  # Password: NorTh@te

╚══════════════════════════════════════════════════════════════════╝
EOF
