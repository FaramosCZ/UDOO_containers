FROM registry.fedoraproject.org/fedora-minimal

LABEL \
   maintainer="Michal Schorm" \
   summary="TeamSpeak 3 GUI client" \
   name="TS3_client" \
   usage="podman run --network host -v /tmp/.X11-unix:/tmp/.X11-unix -e DISPLAY=unix:0 --device /dev/snd -d "

# Default port for virtual voice server (UDP)
EXPOSE 9987/udp
# ServerQuery is listening on port 10011 (TCP) and file transfers will use port 30033 (TCP)

#COPY alias.sh alias_text /etc/profile.d/



ENV TS_CLIENT_VERSION 3.5.0

RUN set -vx \
    && useradd user \
    && microdnf install wget tree nano less tar bzip2 procps-ng

USER user
WORKDIR /home/user/



# Fetch the client
RUN set -vx \
    && wget https://files.teamspeak-services.com/releases/client/${TS_CLIENT_VERSION}/TeamSpeak3-Client-linux_amd64-${TS_CLIENT_VERSION}.run \
    && chmod +x TeamSpeak3-Client-linux_amd64-${TS_CLIENT_VERSION}.run

# Edit out the licence opening in 'less' and send the script few characters to accept the licence
RUN set -vx \
    && sed -i 's/    echo "$licensetxt" | less/ /' TeamSpeak3-Client-linux_amd64-${TS_CLIENT_VERSION}.run \
    && echo -e "\n:q\ny\n" | ./TeamSpeak3-Client-linux_amd64-${TS_CLIENT_VERSION}.run

# We are gonna install more packages
USER root
WORKDIR /home/user/TeamSpeak3-Client-linux_amd64/

# Solve all missing libraries, found by 'ldd'
RUN set -vx \
    && microdnf install `ldd ts3client_linux_amd64 ./*so | grep "not found" | sort | uniq | sed 's/=>.*$//' | sed 's|^[[:blank:]]*|/usr/lib64/|' `
# And two more hidden missing libraries
RUN set -vx \
    && microdnf install /usr/lib64/libxslt.so /usr/lib64/libpulse.so.0


USER user

CMD ./ts3client_runscript.sh
