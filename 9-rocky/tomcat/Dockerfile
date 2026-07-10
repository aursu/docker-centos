ARG rocky=9.8.20260525.0
# NOTE: jdk-26 is currently published bare (Docker Hub). When the registry
# drift is fixed (see 9-rocky/RECOMMENDATIONS.md P1.1), move this to
# ghcr.io/aursu/rockylinux together with jdk-26.
FROM aursu/rockylinux:${rocky}-jdk-26

ARG MYSQL_CONN_NAME=mysql-connector-j-9.7.0
ARG MYSQL_CONN_RPM=${MYSQL_CONN_NAME}-1.el9.noarch.rpm
ARG MYSQL_CONN_URL=https://cdn.mysql.com//Downloads/Connector-J/${MYSQL_CONN_RPM}

LABEL org.opencontainers.image.source=https://github.com/aursu/docker-centos

ENV CATALINA_HOME=/usr/share/tomcat
ENV CATALINA_BASE=/usr/share/tomcat
ENV CATALINA_TMPDIR=/var/cache/tomcat/temp
ENV JAVA_HOME=/usr/lib/jvm/jre
ENV CLASSPATH=/usr/share/java/${MYSQL_CONN_NAME}.jar

# `tomcat` pulls its own runtime deps: tomcat-lib, javapackages-tools
# (java-functions + build-classpath) and ecj (JSP compiler). The jdk-26 base
# stays the highest-priority `jre` alternative, so Tomcat runs on JDK 26.
RUN microdnf -y install tomcat \
    && microdnf clean all && rm -rf /var/cache/dnf /var/lib/rpm/__db*

# MySQL Connector/J (JDBC driver), published on the shared classpath via
# $CLASSPATH. Not in the EL9 repos, so fetched + signature-checked from MySQL.
RUN set -ex; \
    curl -fL ${MYSQL_CONN_URL} -o /tmp/${MYSQL_CONN_RPM}; \
    rpm --import https://repo.mysql.com/RPM-GPG-KEY-mysql-2023; \
    rpm --checksig /tmp/${MYSQL_CONN_RPM}; \
    rpm -ivh /tmp/${MYSQL_CONN_RPM}; \
    rm -f /tmp/${MYSQL_CONN_RPM}; \
    rm -rf /root/.gnupg

USER tomcat
WORKDIR ${CATALINA_HOME}

# Stock EL9 `functions` already `exec`s the JVM (run_java = eval "exec …"),
# so java becomes PID 1 and `docker stop` shuts Tomcat down gracefully.
CMD ["/usr/libexec/tomcat/server", "start"]
