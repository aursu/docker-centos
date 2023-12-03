ARG centos=7.9.2009
FROM aursu/centos:${centos}-jdk-11

ARG MYSQL_CONN_NAME=mysql-connector-j-8.2.0
ARG MYSQL_CONN_RPM=${MYSQL_CONN_NAME}-1.el7.noarch.rpm
ARG MYSQL_CONN_URL=https://cdn.mysql.com//Downloads/Connector-J/${MYSQL_CONN_RPM}
ARG MYSQL_CONN_PATH=/tmp/${MYSQL_CONN_RPM}
ARG MYSQL_PUBKEY=3A79BD29

ENV JAVA_ABRT=off
ENV TOMCATS_BASE=/var/lib/tomcats/
ENV JAVA_HOME=/usr/lib/jvm/jre
ENV CATALINA_HOME=/usr/share/tomcat
ENV CATALINA_TMPDIR=/var/cache/tomcat/temp
ENV JAVA_LIBDIR=/usr/share/java
ENV JNI_LIBDIR=/usr/lib/java
ENV JVM_ROOT=/usr/lib/jvm
ENV CATALINA_BASE $CATALINA_HOME
ENV JAVACMD ${JAVA_HOME}/bin/java
ENV LOGGING_PROPERTIES ${CATALINA_BASE}/conf/logging.properties
ENV CLASSPATH=/usr/share/java/${MYSQL_CONN_NAME}.jar

RUN yum -y install \
        apache-commons-daemon \
        java-headless \
        javapackages-tools \
        mysql \
        tomcat \
        tomcat-lib \
    && yum clean all && rm -rf /var/cache/yum /var/lib/rpm/__db*

RUN set -ex; \
    curl -L ${MYSQL_CONN_URL} -o ${MYSQL_CONN_PATH}; \
    rpm --import https://repo.mysql.com/RPM-GPG-KEY-mysql-2022; \
    rpm --checksig ${MYSQL_CONN_PATH}; \
    rpm -ivh ${MYSQL_CONN_PATH}; \
    rm -f ${MYSQL_CONN_PATH}; \
    rm -rf /root/.gnupg

# switch from eval() call to exec() inside run() function to support Docker
COPY system/usr/libexec/tomcat/functions /usr/libexec/tomcat/functions

RUN mkdir -p $CATALINA_BASE/webapps \
    && mkdir -p /etc/tomcat/conf.d

USER tomcat
WORKDIR $CATALINA_HOME
CMD /usr/libexec/tomcat/server start
