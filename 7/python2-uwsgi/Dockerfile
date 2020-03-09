ARG centos=7.7.1908
FROM aursu/centos:${centos}-base

RUN yum -y install \
        python2-pip \
        python2-uwsgidecorators \
        uwsgi \
        uwsgi-plugin-python2 \
    && yum clean all && rm -rf /var/cache/yum /var/lib/rpm/__db* \
    && pip install --upgrade pip