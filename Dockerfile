FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV USER=ubuntu
ENV PASSWORD=
ENV VNC_PORT=5900
ENV NOVNC_PORT=6080
ENV DISPLAY=:1
ENV TZ=Etc/UTC

# Install required packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    xfce4 \
    xfce4-goodies \
    x11vnc \
    xvfb \
    novnc \
    websockify \
    supervisor \
    net-tools \
    openssh-server \
    xrdp \
    dbus-x11 \
    firefox \
    tigervnc-standalone-server \
    tigervnc-common \
    sudo \
    wget \
    curl \
    unzip \
    python3 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Create a user with passwordless sudo
RUN useradd -m -s /bin/bash $USER \
    && echo "$USER ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers \
    && echo "$USER:$PASSWORD" | chpasswd

# Set up noVNC
RUN mkdir -p /opt/novnc \
    && wget -qO- https://github.com/novnc/noVNC/archive/refs/heads/master.tar.gz | tar xz --strip 1 -C /opt/novnc \
    && wget -qO- https://github.com/novnc/websockify/archive/refs/heads/master.tar.gz | tar xz --strip 1 -C /opt/novnc/utils/websockify \
    && ln -s /opt/novnc/vnc_lite.html /opt/novnc/index.html

# Configure XFCE and VNC
RUN mkdir -p /home/$USER/.vnc \
    && echo "#!/bin/sh" > /home/$USER/.vnc/xstartup \
    && echo "unset SESSION_MANAGER" >> /home/$USER/.vnc/xstartup \
    && echo "unset DBUS_SESSION_BUS_ADDRESS" >> /home/$USER/.vnc/xstartup \
    && echo "exec startxfce4" >> /home/$USER/.vnc/xstartup \
    && chmod +x /home/$USER/.vnc/xstartup \
    && chown -R $USER:$USER /home/$USER/.vnc

# Configure xrdp
RUN sed -i 's/port=3389/port=3390/g' /etc/xrdp/xrdp.ini \
    && echo "xfce4-session" > /home/$USER/.xsession \
    && chown $USER:$USER /home/$USER/.xsession

# Set up supervisor
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Expose ports
EXPOSE $NOVNC_PORT $VNC_PORT 3390

# Start the container
CMD ["/usr/bin/supervisord"]
