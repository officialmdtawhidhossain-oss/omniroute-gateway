FROM node:22-bullseye-slim

# Install basic build tools and utilities
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Set up user for Hugging Face Spaces (UID 1000)
RUN useradd -m -u 1000 user
ENV HOME=/home/user \
    PATH=/home/user/.local/bin:$PATH \
    PORT=7860 \
    DATA_DIR=/home/user/.omniroute \
    NODE_ENV=production

WORKDIR /home/user/app

# Create data directory with proper permissions
RUN mkdir -p /home/user/.omniroute && chown -R user:user /home/user

USER user

# Install omniroute into user's local bin
RUN npm install -g omniroute --prefix /home/user/.local

EXPOSE 7860

CMD ["/home/user/.local/bin/omniroute", "serve", "--port", "7860", "--no-open"]
