FROM dorowu/ubuntu-desktop-lxde-vnc

USER root

# Remove broken Chrome repo to avoid GPG error
RUN rm -f /etc/apt/sources.list.d/google-chrome.list || true

# Now update and install Firefox
RUN apt-get update && \
    apt-get install -y firefox && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

EXPOSE 80

CMD ["/startup.sh"]
