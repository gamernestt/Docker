FROM dorowu/ubuntu-desktop-lxde-vnc

# Install Firefox
RUN apt-get update && \
    apt-get install -y firefox && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Expose noVNC web port
EXPOSE 80

CMD ["/startup.sh"]
