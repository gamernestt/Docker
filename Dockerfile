FROM dorowu/ubuntu-desktop-lxde-vnc

USER root

# Clean any broken sources
RUN rm -f /etc/apt/sources.list.d/google-chrome.list || true

# Install a lightweight browser (Midori)
RUN apt-get update && \
    apt-get install -y midori && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Launch Midori on boot
RUN echo '#!/bin/bash\n/startup.sh &\nsleep 3\nmidori &' > /usr/local/bin/start-midori && \
    chmod +x /usr/local/bin/start-midori

EXPOSE 80

CMD ["/usr/local/bin/start-midori"]
