ARG rocky=9.4.20240509
ARG image=nginx
FROM aursu/rockylinux:${rocky}-${image}

RUN curl -L https://openresty.org/package/rocky/openresty2.repo -o /tmp/openresty.repo \
	&& mv /tmp/openresty.repo /etc/yum.repos.d/openresty.repo

RUN microdnf -y install \
		openresty \
		openresty-debug \
	&& microdnf clean all && rm -rf /var/cache/dnf /var/lib/rpm/__db* \
	&& mkdir -p /usr/local/openresty/nginx/conf/conf.d

COPY system/etc/nginx/nginx.conf /usr/local/openresty/nginx/conf/nginx.conf

RUN mkdir -p /var/cache/nginx/proxy_temp \
	&& chown -R www-data:www-data /var/cache/nginx/proxy_temp

COPY system/etc/nginx/conf.d/00-proxy.conf /usr/local/openresty/nginx/conf/conf.d/00-proxy.conf

CMD ["/usr/local/openresty/nginx/sbin/nginx", "-g", "daemon off;"]
