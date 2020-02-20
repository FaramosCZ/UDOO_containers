FROM registry.fedoraproject.org/fedora-minimal

LABEL \
   maintainer="Michal Schorm" \
   summary="TeamSpeak 3 headless server" \
   name="TS3_server" \
   usage="podman run --network host -d "

# Default port for virtual voice server (UDP)
EXPOSE 9987/udp
# ServerQuery is listening on port 10011 (TCP) and file transfers will use port 30033 (TCP)

COPY alias.sh alias_text /etc/profile.d/



ENV TS_SERVER_VERSION 3.11.0

RUN set -vx \
    && useradd user \
    && microdnf install wget tree nano less tar bzip2 procps-ng

USER user
WORKDIR /home/user/



# Fetch the server
RUN set -vx \
    && wget https://files.teamspeak-services.com/releases/server/${TS_SERVER_VERSION}/teamspeak3-server_linux_amd64-${TS_SERVER_VERSION}.tar.bz2 \
    && tar -xof teamspeak3-server_linux_amd64-${TS_SERVER_VERSION}.tar.bz2

WORKDIR /home/user/teamspeak3-server_linux_amd64/

# First run of the server, get & save priviledge keys and administrator credentials
RUN set -vx \
    && touch .ts3server_license_accepted \
    && timeout 15 ./ts3server pidfile=ts3server.pid 2> /home/user/TS3_SERVER_SECRETS || : \
    && cat /home/user/TS3_SERVER_SECRETS



# Command to be ran by default, IF NOT OVERRIDDEN
CMD ./ts3server pidfile=ts3server.pid
