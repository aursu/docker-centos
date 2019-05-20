FROM aursu/centos:7-base

ARG pip_version="19.1.1"

RUN yum -y install \
        python2-pip \
        python2-uwsgidecorators \
        uwsgi \
        uwsgi-plugin-python2 \
    && yum clean all && rm -rf /var/cache/yum /var/lib/rpm/__db* \
    && pip install --upgrade pip==${pip_version}