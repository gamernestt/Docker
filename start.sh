#!/bin/bash

# Start xrdp
service xrdp start

# Start VNC server without password
vncserver :1 -geometry 1280x720 -depth 24 -nopw

# Start noVNC
/usr/share/novnc/utils/novnc_proxy --vnc localhost:5901 --listen 0.0.0.0:6080 &

# Keep container running
tail -f /dev/null
