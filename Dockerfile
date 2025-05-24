# Use a slim Debian base image
FROM debian:bullseye-slim

# Install dependencies including xauth
RUN apt-get update && apt-get install -y \
    chromium \
    fonts-liberation \
    x11-utils \
    xvfb \
    xauth \
    libnss3 \
    libxss1 \
    libasound2 \
    libatk-bridge2.0-0 \
    libgtk-3-0 \
    wget \
    curl \
    unzip \
    --no-install-recommends && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Create a non-root user
RUN useradd -m chromeuser
USER chromeuser
WORKDIR /home/chromeuser

# Optional: expose a port if you want remote debugging
EXPOSE 9222

# Run Chromium headless with virtual framebuffer
CMD ["sh", "-c", "xvfb-run -a chromium --no-sandbox --disable-gpu --disable-software-rasterizer --headless --disable-dev-shm-usage --remote-debugging-port=9222 https://example.com"]
