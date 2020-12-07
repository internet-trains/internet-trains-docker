FROM ubuntu:latest

# ENV
ENV DEBIAN_FRONTEND=noninteractive

# FIX FOR BUILD-DEPS
RUN cp /etc/apt/sources.list /etc/apt/sources.list~
RUN sed -Ei 's/^# deb-src /deb-src /' /etc/apt/sources.list

# DEPS
RUN apt-get update 
RUN apt-get build-dep openttd -y 
RUN apt-get install git cmake wget unzip python3 -y

# JGRPP OPENTTD BUILD SETUP
RUN git clone https://github.com/JGRennison/OpenTTD-patches --branch=jgrpp-0.39.1 openttd && mkdir openttd/build

# MAKE OPENTTD
WORKDIR openttd/build/
RUN ls && cmake .. && make --jobs=5
RUN cd baseset && wget https://cdn.openttd.org/opengfx-releases/0.6.0/opengfx-0.6.0-all.zip -O opengfx.zip && unzip opengfx.zip

# CONFIG SETUP
COPY openttd.cfg /root/.config/openttd/openttd.cfg
COPY cdn.cfg /root/.config/openttd/cdn.cfg
COPY download_content.py .

# STANDARD ADD-ONS
# SERVER GS
RUN git clone https://github.com/internet-trains/ServerGS.git ./game/ServerGS
WORKDIR /openttd/build/game/ServerGS
RUN python3 ./gen_api_binding.py

# DOWNLOAD CONTENT
WORKDIR /openttd/build/
RUN mkdir -p ~/.local/share/openttd/ 
RUN python3 ./download_content.py
RUN cp -r ./content_download/ ~/.local/share/openttd/content_download/

# EXPOSE PORTS
EXPOSE 3979/tcp
EXPOSE 3979/udp
