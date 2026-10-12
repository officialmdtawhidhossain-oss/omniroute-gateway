FROM node:22-bullseye-slim

# Install basic utilities
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Setup non-root container user
RUN useradd -m -u 1000 user
ENV HOME=/home/user \
    PATH=/home/user/.local/bin:$PATH \
    DATA_DIR=/home/user/.omniroute \
    NODE_ENV=production

WORKDIR /home/user/app

# Ensure storage directory exists with proper permissions
RUN mkdir -p /home/user/.omniroute && chown -R user:user /home/user

USER user

# Install omniroute globally for the container user
RUN npm install -g omniroute --prefix /home/user/.local

# Default port (Cloud providers like Render inject dynamic $PORT)
EXPOSE 20128

CMD ["sh", "-c", "/home/user/.local/bin/omniroute serve --port ${PORT:-20128} --no-open"]
