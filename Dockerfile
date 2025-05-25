FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Install required packages
RUN apt update && apt install -y \
    xfce4 xfce4-goodies \
    tigervnc-standalone-server \
    novnc websockify \
    xterm wget curl net-tools \
    firefox \
    python3 python3-websockify \
    sudo

# Create non-root user
RUN useradd -m ubuntu && echo "ubuntu ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Set up VNC xstartup script as ubuntu user
USER ubuntu
RUN mkdir -p /home/ubuntu/.vnc && \
    echo "#!/bin/sh\nxrdb \$HOME/.Xresources\nstartxfce4 &" > /home/ubuntu/.vnc/xstartup && \
    chmod +x /home/ubuntu/.vnc/xstartup

USER root

# Set up noVNC symlinks
RUN mkdir -p /opt/novnc/utils/websockify && \
    ln -s /usr/share/novnc /opt/novnc && \
    ln -s /usr/share/novnc/utils/websockify /opt/novnc/utils/websockify

# Expose noVNC port
EXPOSE 6080

# Start VNC and noVNC (no password)
CMD su - ubuntu -c "\
    vncserver :1 -geometry 1280x720 -SecurityTypes None && \
    /opt/novnc/utils/novnc_proxy --vnc localhost:5901 --listen 6080"
