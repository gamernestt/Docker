# Base image
FROM debian:bullseye-slim

# Install dependencies
RUN apt-get update && apt-get install -y \
    chromium \
    fonts-liberation \
    x11-utils \
    xvfb \
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

# Create user to avoid running as root
RUN useradd -m chromeuser
USER chromeuser
WORKDIR /home/chromeuser

# Optional: expose a port if you plan to use remote debugging
EXPOSE 9222

# Entry point: Run Chromium in headless mode using XVFB
CMD ["sh", "-c", "xvfb-run -a chromium --no-sandbox --disable-gpu --disable-software-rasterizer --headless --disable-dev-shm-usage --remote-debugging-port=9222 https://example.com"]
