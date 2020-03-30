podman run \
  -d --network host \
  -v /home/lod/UDOO_containers/data/ts3server.sqlitedb:/home/user/teamspeak3-server_linux_amd64/ts3server.sqlitedb \
  localhost/ts3_server
