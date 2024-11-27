ARG rocky=9.5.20241118
ARG image=web
FROM aursu/rockylinux:${rocky}-${image}

EXPOSE 80 443
STOPSIGNAL SIGQUIT

RUN microdnf -y module enable nginx:1.24 \
    && microdnf -y install \
		nginx-1.24.0 \
	&& microdnf clean all && rm -rf /var/cache/dnf /var/lib/rpm/__db*

RUN openssl dhparam -out /etc/nginx/dhparam.pem 4096 \
	# forward request and error logs to docker log collector
	&& ln -sf /dev/stdout /var/log/nginx/access.log \
	&& ln -sf /dev/stderr /var/log/nginx/error.log \
	&& mkdir -p /var/cache/nginx \
	&& chown -R www-data:www-data /var/cache/nginx

COPY system/etc/nginx/nginx.conf /etc/nginx/nginx.conf

CMD ["nginx", "-g", "daemon off;"]
