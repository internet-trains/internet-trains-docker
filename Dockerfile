FROM ubuntu:latest

LABEL maintainer="https://github.com/internet-trains/internet-trains-docker/"

ENV DEBIAN_FRONTEND=noninteractive \
    PORT=3979 \
    ADMIN_PORT=3977 \
    USER_FOLDER=/root/.local/share \
    SOURCE=https://github.com/JGRennison/OpenTTD-patches \
    BRANCH=jgrpp-0.50.0

# FIX FOR BUILD-DEPS
RUN cp /etc/apt/sources.list /etc/apt/sources.list~
RUN sed -Ei 's/^# deb-src /deb-src /' /etc/apt/sources.list

# DEPS
RUN apt-get update
RUN apt-get build-dep openttd -y
RUN apt-get install git cmake wget unzip python3 -y

# JGRPP OPENTTD BUILD SETUP
RUN git clone "$SOURCE" --branch="$BRANCH" openttd \
    && mkdir openttd/build

# MAKE OPENTTD
WORKDIR openttd/build/
RUN ls && cmake .. && make --jobs=5
RUN cd baseset && wget https://cdn.openttd.org/opengfx-releases/7.1/opengfx-7.1-all.zip -O opengfx.zip && unzip opengfx.zip

# CONFIG SETUP
COPY openttd.cfg /root/.config/openttd/openttd.cfg
COPY cdn.cfg /root/.config/openttd/cdn.cfg
COPY download_content.py .


# SERVER GS
RUN git clone https://github.com/internet-trains/ServerGS.git ./game/ServerGS
WORKDIR /openttd/build/game/ServerGS
RUN python3 ./gen_api_binding.py

# EXPOSE PORTS
EXPOSE $PORT/tcp $PORT/udp
EXPOSE $ADMIN_PORT/tcp $ADMIN_PORT/udp

STOPSIGNAL SIGQUIT
