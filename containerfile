FROM registry.fedoraproject.org/fedora-minimal

LABEL \
   summary="Most basic GUI app for testing GUI containers" \
   name="xeyes" \
   usage="podman run -d -v /tmp/.X11-unix:/tmp/.X11-unix -e DISPLAY=:0"


RUN set -vx \
    && microdnf install xeyes

CMD /usr/bin/xeyes -geometry +10+10
