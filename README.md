# Internet Trains for Docker

### Build Container
```bash
docker build -t internet-trains:latest .
```

### Run Container
```bash
docker run -p 3979:3979/tcp -p 3979:3979/udp -it internet-trains /openttd/build/openttd -D
```
