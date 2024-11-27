ARG rocky=9.5.20241118
FROM aursu/rockylinux:${rocky}-webdev

COPY docker-entrypoint.sh /usr/local/libexec/

RUN groupadd -g 1000 node \
  && useradd -u 1000 -g node -s /bin/bash -m node \
  && chmod +x /usr/local/libexec/docker-entrypoint.sh

RUN microdnf -y module enable nodejs:20 \
  && microdnf -y install \
    nodejs-1:20.16.0 \
    npm \
  && npm install -g \
    npm@10.8.3 \
    yarn@1.22.22 \
  && rm -rf /root/.npm \
  && rpm -e npm \
  && microdnf clean all && rm -rf /var/cache/dnf /var/lib/rpm/__db*

ENTRYPOINT ["/usr/local/libexec/docker-entrypoint.sh"]
CMD [ "node" ]
