ARG rocky=10.0.20250606
FROM aursu/rockylinux:${rocky}-scm

ENV container docker
ENV LC_ALL=en_US.utf-8
ENV LANG=en_US.utf-8

RUN microdnf -y install \
        systemd \
        dbus \
    && microdnf clean all && rm -rf /var/cache/dnf /var/lib/rpm/__db*; \
(cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == \
systemd-tmpfiles-setup.service ] || rm -f $i; done); \
rm -f /lib/systemd/system/multi-user.target.wants/*;\
rm -f /etc/systemd/system/*.wants/*;\
rm -f /lib/systemd/system/local-fs.target.wants/*; \
rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
rm -f /lib/systemd/system/basic.target.wants/*;\
rm -f /lib/systemd/system/anaconda.target.wants/*;

CMD ["/usr/sbin/init"]
