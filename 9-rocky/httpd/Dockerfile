ARG rocky=9.4.20240523
FROM aursu/rockylinux:${rocky}-base

ENV LANG=en_US.utf-8

RUN microdnf -y install \
		httpd \
	&& microdnf clean all && rm -rf /var/cache/dnf /var/lib/rpm/__db*

RUN rm -f /etc/httpd/conf.modules.d/*.conf /etc/httpd/conf.d/*.conf

COPY system/etc/httpd/conf/httpd.conf /etc/httpd/conf/httpd.conf
COPY system/etc/httpd/conf.modules.d/00-mpm.conf \
	/etc/httpd/conf.modules.d/00-mpm.conf
COPY system/etc/httpd/conf.modules.d/00-base.conf \
	/etc/httpd/conf.modules.d/00-base.conf

EXPOSE 80
CMD [ "/usr/sbin/httpd", "-DFOREGROUND"]
