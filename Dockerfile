FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update && apt-get install -y \
    chromium-browser \
    x11vnc \
    xvfb \
    supervisor \
    websockify \
    net-tools \
    wget \
    python3 \
    python3-pip \
    curl \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Install noVNC
RUN mkdir -p /opt/novnc/utils/websockify && \
    git clone https://github.com/novnc/noVNC /opt/novnc && \
    git clone https://github.com/novnc/websockify /opt/novnc/utils/websockify

# Set up supervisord config
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

EXPOSE 80

CMD ["/usr/bin/supervisord"]
