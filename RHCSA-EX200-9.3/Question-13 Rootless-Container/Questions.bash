#!/bin/bash
cat <<'EOF'
╔══════════════════════════════════════════════════════════════════╗
║  QUESTION 13 — Rootless Container as Systemd Service (serverb)  ║
╠══════════════════════════════════════════════════════════════════╣
║                                                                  ║
║  As the user "student", configure a rootless container:         ║
║                                                                  ║
║  a) Pull the image: docker.io/admin034/monitor:latest           ║
║     (Credentials: admin034 / redhat321)                         ║
║                                                                  ║
║  b) Create a container named "ascii2pdf"                        ║
║                                                                  ║
║  c) Mount the following persistent volumes:                     ║
║     - Host /opt/files     → Container /opt/incoming   (:Z)     ║
║     - Host /opt/processed → Container /opt/outgoing   (:Z)     ║
║                                                                  ║
║  d) Create a systemd user service called                        ║
║     "container-ascii2pdf" for this container                    ║
║                                                                  ║
║  e) The service must auto-start on system reboot                ║
║     (enable lingering for user student)                         ║
║                                                                  ║
╚══════════════════════════════════════════════════════════════════╝
EOF
