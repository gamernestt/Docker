FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

# Install required packages
RUN apt-get update && apt-get install -y \
    chromium-browser \
    x11vnc \
    xvfb \
    git \
    supervisor \
    wget \
    python3 \
    python3-pip \
    curl \
    net-tools \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Install noVNC and websockify
RUN git clone https://github.com/novnc/noVNC /opt/novnc && \
    git clone https://github.com/novnc/websockify /opt/novnc/utils/websockify

# Copy supervisor config
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

EXPOSE 80

CMD ["/usr/bin/supervisord"]
