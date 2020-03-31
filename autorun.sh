# First we need to create a Host Pulseaudio unix socket so we can mount it into the container
pactl load-module module-native-protocol-unix auth-anonymous=1 socket=/tmp/pulseaudio.socket



# Second we need to create a configuration file to mount into the container
cat << EOF > /tmp/pulseaudio.client.conf
default-server = unix:/tmp/pulseaudio.socket
# Prevent a server running in the container
autospawn = no
daemon-binary = /bin/true
# Prevent the use of shared memory
enable-shm = false
EOF



# Now we can finally run the container
podman run \
  -ti --network host \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  --env PULSE_SERVER=unix:/tmp/pulseaudio.socket \
  --env PULSE_COOKIE=/tmp/pulseaudio.cookie \
  --volume /tmp/pulseaudio.socket:/tmp/pulseaudio.socket \
  --volume /tmp/pulseaudio.client.conf:/etc/pulse/client.conf \
  -e DISPLAY=:0 \
  ts3_client

#  -v /home/lod/UDOO_containers/data/settings.db:/home/user/TeamSpeak3-Client-linux_amd64/config/settings.db \
