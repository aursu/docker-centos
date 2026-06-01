ARG rocky=9.7.20251123
ARG image=web
FROM ghcr.io/aursu/rockylinux:${rocky}-${image}

ARG NGINX_VERSION="1.31.1"

COPY system/etc/yum.repos.d/nginx.repo /etc/yum.repos.d/nginx.repo

EXPOSE 80 443
STOPSIGNAL SIGQUIT

RUN microdnf -y install --enablerepo=nginx-mainline \
		nginx-${NGINX_VERSION} \
	&& microdnf clean all && rm -rf /var/cache/dnf /var/lib/rpm/__db*

RUN openssl dhparam -out /etc/nginx/dhparam.pem 4096 \
	# forward request and error logs to docker log collector
	&& ln -sf /dev/stdout /var/log/nginx/access.log \
	&& ln -sf /dev/stderr /var/log/nginx/error.log \
	&& mkdir -p /var/cache/nginx \
	&& chown -R www-data:www-data /var/cache/nginx

COPY system/etc/nginx/nginx.conf /etc/nginx/nginx.conf

CMD ["nginx", "-g", "daemon off;"]
