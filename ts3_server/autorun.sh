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



# Make the data files readable even for non-privileged container user
chmod a+rw data/*



podman run \
  -d --network host \
  -v `pwd`/data/ts3server.sqlitedb:/home/user/teamspeak3-server_linux_amd64/ts3server.sqlitedb \
  localhost/ts3_server



#----------------------------------------

# Jump back to the directory we were before this script execution
popd
