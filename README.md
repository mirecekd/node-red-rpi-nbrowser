# Node-RED image with nbrowser integration for RPI (armv7l)

## Build image:

```
docker build -t mirecekd/node-red-nbrowser-rpi .
```

## Run image:
```
docker run --name=node-red -p 1880:1880 -p 5900:5900 -v /usr/share/hassio/homeassistant/node-red:/data -v /usr/share/hassio/homeassistant:/config mirecekd/node-red-nbrowser-rpi
```
