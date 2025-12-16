ARG rocky=9.7.20251123
FROM ghcr.io/aursu/rockylinux:${rocky}-web

LABEL org.opencontainers.image.source=https://github.com/aursu/docker-centos

COPY docker-entrypoint.sh /usr/local/libexec/

RUN groupadd -g 1000 node \
  && useradd -u 1000 -g node -s /bin/bash -m node \
  && chmod +x /usr/local/libexec/docker-entrypoint.sh

RUN microdnf -y module enable nodejs:20 \
    && microdnf -y install \
      nodejs-1:20.19.5 \
    && microdnf clean all && rm -rf /var/cache/dnf /var/lib/rpm/__db*

ENTRYPOINT ["/usr/local/libexec/docker-entrypoint.sh"]
CMD [ "node" ]
