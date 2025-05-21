FROM dorowu/ubuntu-desktop-lxde-vnc

USER root

# Remove broken Chrome repo (safety)
RUN rm -f /etc/apt/sources.list.d/google-chrome.list || true

# Install Firefox and dependencies
RUN apt-get update && \
    apt-get install -y firefox dbus-x11 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Set environment variables to disable hardware acceleration
ENV MOZ_DISABLE_RDD_SANDBOX=1
ENV MOZ_ENABLE_WAYLAND=0

# Optional: Create a wrapper script to launch Firefox safely
RUN echo '#!/bin/bash\nfirefox --no-sandbox --safe-mode &' > /usr/local/bin/firefox-launch && \
    chmod +x /usr/local/bin/firefox-launch

EXPOSE 80

# Start the desktop and launch Firefox
CMD ["/bin/bash", "-c", "/startup.sh && firefox-launch"]
