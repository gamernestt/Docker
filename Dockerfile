# Use Ubuntu 24.04 as the base image
FROM ubuntu:24.04

# Set environment variables to avoid user interaction during installation
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=UTC

# Update package list and install necessary packages
RUN apt-get update && apt-get install -y \
    xfce4 xfce4-goodies \
    xrdp \
    tightvncserver \
    novnc \
    websockify \
    firefox \
    net-tools \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Configure xrdp
RUN echo "xfce4-session" > /etc/skel/.xsession \
    && sed -i '/^port=/c\port=3389' /etc/xrdp/xrdp.ini \
    && sed -i '/^use_vsock=/c\use_vsock=false' /etc/xrdp/xrdp.ini

# Set up VNC without password
RUN mkdir -p /root/.vnc \
    && touch /root/.vnc/passwd \
    && chmod 600 /root/.vnc/passwd

# Expose ports for RDP (3389) and noVNC (6080)
EXPOSE 3389 6080

# Copy startup script
COPY start.sh /start.sh
RUN chmod +x /start.sh

# Start services
CMD ["/start.sh"]
