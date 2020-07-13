FROM registry.fedoraproject.org/fedora-minimal

LABEL \
   maintainer="Michal Schorm" \
   summary="Python2 DNF cache proxy server" \
   name="DNF_cache_proxy_server" \
   usage="podman run -d --network host "

# HTTPS port
EXPOSE 8080/tcp
EXPOSE 8080/udp

RUN set -vx \
    && useradd user \
    && microdnf install python2 \
    && microdnf clean all
# it is crucial to cleanup the DNF cache. It reduces the container size to half !

USER user
WORKDIR /home/user/

COPY proxy.py /usr/bin/
RUN chmod a+x /usr/bin/proxy.py

RUN mkdir yum rpms

CMD python2 /usr/bin/proxy.py