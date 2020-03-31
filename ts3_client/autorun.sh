# First we need to create a Host Pulseaudio unix socket so we can mount it into the container
echo -e "\nCreating PA socket ..."
pactl load-module module-native-protocol-unix auth-anonymous=1 socket=/tmp/pulseaudio.socket
echo -e "Done\n"



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
  -d --network host \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  --env PULSE_SERVER=unix:/tmp/pulseaudio.socket \
  --env PULSE_COOKIE=/tmp/pulseaudio.cookie \
  --volume /tmp/pulseaudio.socket:/tmp/pulseaudio.socket \
  --volume /tmp/pulseaudio.client.conf:/etc/pulse/client.conf \
  -e DISPLAY=:0 \
  -v /home/lod/UDOO_containers/data/settings.db:/home/user/.ts3client/settings.db:rw \
  ts3_client
