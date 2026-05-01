#!/bin/bash
cat <<'EOF'
╔══════════════════════════════════════════════════════════════════╗
║  SOLUTION — Q13: Rootless Container as Systemd Service          ║
╠══════════════════════════════════════════════════════════════════╣

** All steps below must be run as user "student" **
  su - student

Step 1: Login to the container registry
  podman login docker.io
  # Username: admin034
  # Password: redhat321

Step 2: Pull the image
  podman pull docker.io/admin034/monitor:latest

Step 3: Create and run the container
  podman run -d --name ascii2pdf \
    -v /opt/files:/opt/incoming:Z \
    -v /opt/processed:/opt/outgoing:Z \
    docker.io/admin034/monitor:latest

Step 4: Create the systemd user service
  mkdir -p ~/.config/systemd/user
  cd ~/.config/systemd/user
  podman generate systemd --name ascii2pdf --new --files

Step 5: Enable the service
  systemctl --user daemon-reload
  systemctl --user start container-ascii2pdf.service
  systemctl --user enable container-ascii2pdf.service

Step 6: Enable lingering (so service starts at boot without login)
  loginctl enable-linger student

Step 7: Verify
  systemctl --user status container-ascii2pdf.service
  podman ps   # Should show ascii2pdf running

╚══════════════════════════════════════════════════════════════════╝
EOF
