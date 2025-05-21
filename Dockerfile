FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

# Install required packages
RUN apt-get update && apt-get install -y \
    firefox \
    xvfb \
    x11vnc \
    fluxbox \
    net-tools \
    wget \
    xterm \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Create a script to launch Firefox in Xvfb and serve via VNC
RUN echo '#!/bin/bash\n\
Xvfb :0 -screen 0 1024x768x16 &\n\
export DISPLAY=:0\n\
fluxbox &\n\
firefox &\n\
x11vnc -display :0 -nopw -forever -shared -rfbport 5900' > /start.sh && chmod +x /start.sh

EXPOSE 5900

CMD ["/start.sh"]
