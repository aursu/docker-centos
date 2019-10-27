FROM aursu/centos:7-base

ENV LANG=C

RUN yum -y install \
		httpd \
	&& yum clean all && rm -rf /var/cache/yum /var/lib/rpm/__db*

RUN rm -f /etc/httpd/conf.modules.d/*.conf /etc/httpd/conf.d/*.conf

COPY system/etc/httpd/conf/httpd.conf /etc/httpd/conf/httpd.conf
COPY system/etc/httpd/conf.modules.d/00-mpm.conf \
	/etc/httpd/conf.modules.d/00-mpm.conf
COPY system/etc/httpd/conf.modules.d/00-base.conf \
	/etc/httpd/conf.modules.d/00-base.conf

EXPOSE 80
CMD [ "/usr/sbin/httpd", "-DFOREGROUND"]
