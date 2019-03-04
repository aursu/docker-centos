FROM aursu/centos:7-curl

RUN groupadd -g 33 -o www-data \
    && useradd -u 33 -g www-data -d /var/www -M -s /sbin/nologin www-data

RUN mkdir -p /var/www/html \
	&& chown www-data:www-data /var/www/html