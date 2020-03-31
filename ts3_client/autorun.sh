#!/bin/bash

#----------------------------------------
# SET UP A RELATIVE PATH

# Determine and set the relative path we are on
#   $BASH_SOURCE is the only trustworthy source of information. But it does not follow symlinks - use readlink to get>
relative_path=$( readlink -f "$BASH_SOURCE" )
# Move to the current script location, to assure relative paths will be configured correctly
pushd "${relative_path%/*}" || exit

#----------------------------------------
# RUN ALL THE AUTORUN SCRIPTS

set -vx



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



# Make the data files readable even for non-privileged container user
chmod a+rw data/*



# Now we can finally run the container
podman run \
  -d --network host \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  -v /tmp/pulseaudio.socket:/tmp/pulseaudio.socket \
  -v /tmp/pulseaudio.client.conf:/etc/pulse/client.conf \
  -e PULSE_SERVER=unix:/tmp/pulseaudio.socket \
  -e PULSE_COOKIE=/tmp/pulseaudio.cookie \
  -e DISPLAY=:0 \
  -v `pwd`/data/settings.db:/home/user/.ts3client/settings.db \
  ts3_client



#----------------------------------------

# Jump back to the directory we were before this script execution
popd
