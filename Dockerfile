FROM arm32v7/node:12-buster
#FROM arm32v7/node:carbon-buster
#FROM arm32v7/node:buster
#

# Switch back to root user to install packages and configure entrypoint
USER root

RUN apt-get update && apt-get install -y \
    xvfb \
    x11-xkb-utils \
    xfonts-100dpi \
    xfonts-75dpi \
    xfonts-scalable \
    xfonts-cyrillic \
    x11-apps \
    x11-xserver-utils \
    x11vnc \
    clang \
    libdbus-1-dev \
    libgtk2.0-dev \
    libnotify-dev \
    libgconf2-dev \
    libasound2-dev \
    libcap-dev \
    libcups2-dev \
    libxtst-dev \
    libxss1 \
    libnss3-dev \
    python-rpi.gpio \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN mkdir -p /usr/src/node-red
RUN mkdir /data

WORKDIR /usr/src/node-red

RUN useradd --home-dir /usr/src/node-red --no-create-home node-red \
    && chown -R node-red:node-red /data \
    && chown -R node-red:node-red /usr/src/node-red

COPY files/package.json /usr/src/node-red
COPY files/entrypoint /

RUN chmod +x /entrypoint

RUN mkdir -m 1777 /tmp/.X11-unix

# Switch back to node-red user to install the nbrowser module and run as non-root user
USER node-red

RUN npm install

RUN npm install node-red-contrib-string node-red-contrib-nbrowser node-red-contrib-home-assistant-websocket

RUN npm uninstall electron
RUN npm install electron@1.7.12

EXPOSE 1880

VOLUME ["/data"]

ENV FLOWS=flows.json
ENV NODE_PATH=/usr/src/node-red/node_modules:/data/node_modules
ENV DEBUG=nightmare
ENTRYPOINT ["/entrypoint"]
#CMD ["npm", "start", "--", "--userDir", "/data"]
