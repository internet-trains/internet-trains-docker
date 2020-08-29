# Internet Trains for Docker

### Build Container
```bash
docker build -t internet-trains:latest .
```

### Run Container
```bash
docker run -p 3979:3979/tcp -p 3979:3979/udp -it internet-trains /openttd/build/openttd -D
```

### Config
Default config is stored in `openttd.cfg`. Edit it and rebuild the container to update the config.