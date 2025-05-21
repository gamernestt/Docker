FROM dorowu/ubuntu-desktop-lxde-vnc

# Switch to root for installing packages
USER root

# Install Firefox (avoid Chrome to fix the GPG error)
RUN apt-get update && \
    apt-get install -y firefox && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Expose default VNC web port
EXPOSE 80

# Start the VNC desktop environment
CMD ["/startup.sh"]
