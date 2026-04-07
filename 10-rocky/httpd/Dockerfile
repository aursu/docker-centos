ARG rocky=10.1.20251126
FROM ghcr.io/aursu/rockylinux:${rocky}-base

ENV LANG=en_US.utf-8

RUN microdnf -y install \
		--nodocs \
		--setopt=install_weak_deps=0 \
		httpd-2.4.63 \
	&& microdnf clean all && rm -rf /var/cache/dnf /var/lib/rpm/__db*

RUN rm -f /etc/httpd/conf.modules.d/*.conf /etc/httpd/conf.d/*.conf

COPY system/etc/httpd/conf/httpd.conf /etc/httpd/conf/httpd.conf
COPY system/etc/httpd/conf.modules.d/00-mpm.conf \
	/etc/httpd/conf.modules.d/00-mpm.conf
COPY system/etc/httpd/conf.modules.d/00-base.conf \
	/etc/httpd/conf.modules.d/00-base.conf

EXPOSE 80
CMD [ "/usr/sbin/httpd", "-DFOREGROUND"]
