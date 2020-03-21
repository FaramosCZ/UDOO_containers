FROM registry.fedoraproject.org/fedora-minimal

LABEL \
   maintainer="Michal Schorm"

RUN microdnf install xeyes

CMD ["/usr/bin/xeyes"]
