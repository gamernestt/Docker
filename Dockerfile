FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Install desktop, VNC server, and noVNC
RUN apt update && apt install -y \
    xfce4 xfce4-goodies \
    tigervnc-standalone-server \
    novnc websockify \
    xterm wget curl net-tools \
    python3 python3-websockify

# Create user
RUN useradd -m ubuntu && \
    echo '#!/bin/sh\nstartxfce4 &' > /home/ubuntu/.vnc/xstartup && \
    chmod +x /home/ubuntu/.vnc/xstartup && \
    chown -R ubuntu:ubuntu /home/ubuntu

# Set up noVNC
RUN mkdir -p /opt/novnc/utils/websockify && \
    ln -s /usr/share/novnc /opt/novnc && \
    ln -s /usr/share/novnc/utils/websockify /opt/novnc/utils/websockify

# Expose port for noVNC
EXPOSE 6080

# Startup script: starts VNC server and noVNC without password
CMD su - ubuntu -c "vncserver :1 -geometry 1280x720 -SecurityTypes None && \
    /opt/novnc/utils/novnc_proxy --vnc localhost:5901 --listen 6080"
