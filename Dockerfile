FROM node:22-bookworm-slim

ENV HOME=/home/node \
    PATH=/home/node/.local/bin:$PATH \
    DATA_DIR=/home/node/.omniroute \
    NODE_ENV=production

WORKDIR /home/node/app

# The official node image already has the 'node' user (UID 1000)
RUN mkdir -p /home/node/.omniroute && chown -R node:node /home/node

USER node

# Install omniroute into user's local directory
RUN npm install -g omniroute --prefix /home/node/.local

EXPOSE 20128

CMD ["sh", "-c", "/home/node/.local/bin/omniroute serve --port ${PORT:-20128} --no-open"]
