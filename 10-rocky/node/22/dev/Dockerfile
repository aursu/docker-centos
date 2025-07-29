ARG rocky=10.0.20250606
FROM ghcr.io/aursu/rockylinux:${rocky}-webdev

LABEL org.opencontainers.image.source=https://github.com/aursu/docker-centos

COPY docker-entrypoint.sh /usr/local/libexec/

RUN groupadd -g 1000 node \
  && useradd -u 1000 -g node -s /bin/bash -m node \
  && chmod +x /usr/local/libexec/docker-entrypoint.sh

RUN microdnf -y install \
    nodejs-1:22.16.0 \
    npm \
  && npm install -g \
    npm@11.4.2 \
    yarn@1.22.22 \
  && rm -rf /root/.npm \
  && rpm -e nodejs-npm \
  && microdnf clean all && rm -rf /var/cache/dnf /var/lib/rpm/__db*

ENTRYPOINT ["/usr/local/libexec/docker-entrypoint.sh"]
CMD [ "node" ]
