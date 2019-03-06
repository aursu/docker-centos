FROM aursu/centos:7-jdk-8

ARG MYSQL_CONN_NAME=mysql-connector-java-5.1.47
ARG MYSQL_CONN_ARCH=${MYSQL_CONN_NAME}.tar.gz
ARG MYSQL_CONN_URL=https://cdn.mysql.com//Downloads/Connector-J/${MYSQL_CONN_ARCH}
ARG MYSQL_CONN_PATH=/tmp/${MYSQL_CONN_ARCH}

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

RUN yum -y install \
        apache-commons-daemon \
        javapackages-tools \
        mysql \
        tomcat \
        tomcat-lib \
    && yum clean all && rm -rf /var/cache/yum /var/lib/rpm/__db*

RUN set -ex; \
    curl -L ${MYSQL_CONN_URL} -o ${MYSQL_CONN_PATH}; \
    tar zxf ${MYSQL_CONN_PATH} -C /tmp; \
    mv /tmp/${MYSQL_CONN_NAME}/${MYSQL_CONN_NAME}-bin.jar ${JAVA_LIBDIR}; \
    ln -s ${JAVA_LIBDIR}/${MYSQL_CONN_NAME}-bin.jar ${CATALINA_BASE}/lib/mysql.jar; \
    rm -rf ${MYSQL_CONN_PATH} /tmp/${MYSQL_CONN_NAME}

# switch from eval() call to exec() inside run() function to support Docker
COPY system/usr/libexec/tomcat/functions /usr/libexec/tomcat/functions

RUN mkdir -p $CATALINA_BASE/webapps \
    && mkdir -p /etc/tomcat/conf.d

USER tomcat
WORKDIR $CATALINA_HOME
CMD /usr/libexec/tomcat/server start
