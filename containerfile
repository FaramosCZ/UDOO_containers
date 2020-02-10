FROM registry.fedoraproject.org/fedora-minimal
LABEL maintainer="Michal Schorm"

COPY alias.sh alias_text /etc/profile.d/

ENV TS_SERVER_VERSION 3.11.0

RUN set -vx \
    && useradd user \
    && microdnf install wget tree nano less tar bzip2 procps-ng

USER user
WORKDIR /home/user/

RUN true \
    && wget https://files.teamspeak-services.com/releases/server/${TS_SERVER_VERSION}/teamspeak3-server_linux_amd64-${TS_SERVER_VERSION}.tar.bz2 \
    && tar -xof teamspeak3-server_linux_amd64-${TS_SERVER_VERSION}.tar.bz2 \
    && cd teamspeak3-server_linux_amd64 \
    && touch .ts3server_license_accepted

WORKDIR /home/user/teamspeak3-server_linux_amd64/

# Command to be ran by default, IF NOT OVERRIDDEN
CMD ./ts3server pidfile=ts3server.pid
