ARG centos=stream9-20220919.0
ARG image=base
FROM aursu/centos:${centos}-${image}

# https://wiki.debian.org/SystemGroups
# www-data: Some web servers run as www-data. Web content should not be owned
# by this user, or a compromised web server would be able to rewrite a web
# site. Data written out by web servers, including log files, will be owned
# by www-data.
RUN groupadd -g 33 www-data \
    && useradd -u 33 -g www-data -d /var/www -M -s /sbin/nologin www-data

RUN mkdir -p /var/www/html \
	&& chown www-data:www-data /var/www/html

# Add crond into web base image
RUN microdnf -y install \
        cronie \
    && microdnf clean all && rm -rf /var/cache/dnf /var/lib/rpm/__db*