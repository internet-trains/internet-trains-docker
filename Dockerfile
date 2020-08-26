FROM ubuntu:latest
ENV DEBIAN_FRONTEND=noninteractive 
RUN cp /etc/apt/sources.list /etc/apt/sources.list~
RUN sed -Ei 's/^# deb-src /deb-src /' /etc/apt/sources.list
RUN apt-get update 
RUN apt-get build-dep openttd -y 
RUN apt-get install git cmake wget unzip -y
RUN git clone https://github.com/internet-trains/OpenTTD-patches.git --branch=jgrpp-0.35.1 openttd && mkdir openttd/build
WORKDIR openttd/build/
RUN ls && cmake .. && make --jobs=5
RUN cd baseset && wget https://cdn.openttd.org/opengfx-releases/0.6.0/opengfx-0.6.0-all.zip -O opengfx.zip && unzip opengfx.zip
EXPOSE 3979/tcp
EXPOSE 3979/udp
