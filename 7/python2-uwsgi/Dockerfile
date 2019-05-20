FROM aursu/centos:7-base

ARG PIP_VERSION="19.1.1"

RUN yum -y install \
        python2-pip \
        python2-uwsgidecorators \
        uwsgi \
        uwsgi-plugin-python2 \
    && yum clean all && rm -rf /var/cache/yum /var/lib/rpm/__db* \
    && pip install "pip==${PIP_VERSION}"