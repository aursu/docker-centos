ARG centos=stream9-20250520.0
FROM aursu/centos:${centos}-webdev

COPY docker-entrypoint.sh /usr/local/libexec/

RUN groupadd -g 1000 node \
  && useradd -u 1000 -g node -s /bin/bash -m node \
  && chmod +x /usr/local/libexec/docker-entrypoint.sh

RUN microdnf -y module enable nodejs:22 \
  && microdnf -y install \
    nodejs-1:22.16.0 \
    npm \
  && npm install -g \
    npm@11.4.1 \
    yarn@1.22.22 \
  && rm -rf /root/.npm \
  && rpm -e npm \
  && microdnf clean all && rm -rf /var/cache/dnf /var/lib/rpm/__db*

ENTRYPOINT ["/usr/local/libexec/docker-entrypoint.sh"]
CMD [ "node" ]
