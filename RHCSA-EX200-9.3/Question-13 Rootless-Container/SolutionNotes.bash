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
  sudo chown -R $USER:$USER /opt/files /opt/processed

  podman run -d --name ascii2pdf \
    -v /opt/files:/opt/incoming:Z \
    -v /opt/processed:/opt/outgoing:Z \
    docker.io/admin034/monitor:latest

Step 4: Create the systemd user service
  mkdir -p ~/.config/systemd/user
  cd ~/.config/systemd/user
  podman generate systemd --name ascii2pdf --new --files

Step 5: Enable the service
  export XDG_RUNTIME_DIR="/run/user/$(id -u)"
  export DBUS_SESSION_BUS_ADDRESS="unix:path=${XDG_RUNTIME_DIR}/bus"
  systemctl --user daemon-reload
  systemctl --user start container-ascii2pdf.service
  systemctl --user enable container-ascii2pdf.service

Step 6: Enable lingering (so service starts at boot without login)
  loginctl enable-linger student

Step 7: Verify
  systemctl --user status container-ascii2pdf.service
  podman ps   # Should show ascii2pdf running

╚══════════════════════════════════════════════════════════════════╝

╔══════════════════════════════════════════════════════════════════╗
║  SOLUTION — Q13: Rootless Container as Systemd Service          ║
╠══════════════════════════════════════════════════════════════════╣
*** Create a container from Containerfile ****
** All steps below must be run as user "balmeida", you must create it**

Step1: Creat/build a container named watcher as balmeida user 
  useradd balmeida
  ssh balmeida@localhost

  Containerfile:
  FROM registry.access.redhat.com/ubi8/ubi-ini
  RUN dnf -y install httpd; dnf clean all; systemclt enable --now httpd;
  RUN echo "Sucessful Web Server Test" > /var/www/html/index.html
  RUN mkdir /etc/systemd/system/httpd.service.d/; echo -e '[Service]\nRestart=always' > /etc/systemd/system/httpd.service/httpd.conf
  EXPOSE 80
  CMD [ "/sbin/init" ]

  Create image
  podman build -t watcher .

Step2: Mount /data/input directory to /data/output on container:

  podman run -d --name watcher \
  -v /data/input:/data/output:Z \
  watcher

Ste3: Container should run as systemd service named as "container-watcher"

  mkdir ~/.config/systemd/user
  cd ~/.config/systemd/user
  podman generate systemd --name watcher --files --new
  systemctl --user daemon-reload
  systemctl --user start container-watcher.service
  systemctl --user enable container-watcher.service

╚══════════════════════════════════════════════════════════════════╝

EOF
