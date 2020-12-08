# Internet Trains for Docker

### Build Container
```bash
docker build -t internet-trains:latest .
```

### Run Container
```bash
docker run -itd -p 3979:3979/tcp -p 3979:3979/udp -p 3977:3977/tcp -p 3977:3977/udp -v /opt/OpenTTD:/opt/openttd --name openttd internet-trains /openttd/build/openttd -D
```
This will link all user files on the host machine in `/opt/OpenTTD` to the user
directory in the container.

### Config
Default config is stored in `openttd.cfg`. Edit it and rebuild the container to update the config.
