ARG rocky=10.0.20250606
ARG image=base
FROM ghcr.io/aursu/rockylinux:${rocky}-${image}

LABEL org.opencontainers.image.source=https://github.com/aursu/docker-centos

# uid 33 assigned to group tape
# (https://bugzilla.redhat.com/show_bug.cgi?id=1179585)
# do we need tape drive for web app containers?
#
# https://wiki.debian.org/SystemGroups
# www-data: Some web servers run as www-data. Web content should not be owned
# by this user, or a compromised web server would be able to rewrite a web
# site. Data written out by web servers, including log files, will be owned
# by www-data.
RUN groupdel tape \
    && groupadd -g 33 www-data \
    && useradd -u 33 -g www-data -d /var/www -M -s /sbin/nologin www-data

RUN mkdir -p /var/www/html \
	&& chown www-data:www-data /var/www/html
