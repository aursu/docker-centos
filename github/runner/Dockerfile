ARG rocky=8.7.20221112
FROM aursu/rockylinux:${rocky}-scm

ARG RUNNER_VERSION=2.299.1
ARG SHASUM=147c14700c6cb997421b9a239c012197f11ea9854cd901ee88ead6fe73a72c74
ARG DISTRO=actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz
ARG RELEASE_URL="https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/${DISTRO}"

ARG user=runner
ARG group=runner
ARG home=/home/${user}
ARG uid=1000
ARG gid=1000

ENV RUNNER_USER $user
ENV RUNNER_HOME $home

RUN mkdir -p $RUNNER_HOME/work \
  && chown $uid:$gid $RUNNER_HOME \
  && groupadd -g $gid $group \
  && useradd -d $RUNNER_HOME -u $uid -g $gid -m -s /bin/bash $RUNNER_USER

RUN microdnf -y install \
        libicu \
        lttng-ust \
        tar \
    && microdnf clean all && rm -rf /var/cache/dnf /var/lib/rpm/__db*

WORKDIR $RUNNER_HOME

RUN set -ex \
    && curl -O -L $RELEASE_URL \
    && echo "${SHASUM} ${DISTRO}" | sha256sum -c \
    && tar zxf $DISTRO \
    && rm -f $DISTRO

USER $RUNNER_USER

RUN set -ex \
    && $RUNNER_HOME/config.sh --unattended --url $GITHUB_URL --token $GITHUB_TOKEN --work $RUNNER_HOME/work

CMD ["${RUNNER_HOME}/run.sh"]
