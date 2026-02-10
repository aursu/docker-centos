ARG rocky=9.7.20251123
ARG image=ruby33
FROM aursu/rockylinux:${rocky}-${image}

ARG platform=puppet8
ARG DNF_ENV_FILE=/dev/null
ARG AGENT_VERSION="8.16.0"
ARG BOLT_VERSION="5.0.1"
ARG PDK_VERSION="3.6.1.1"

RUN --mount=type=secret,id=forge_key,required \
	rpm -ivh https://yum-puppetcore.puppet.com/public/${platform}-release-el-9.noarch.rpm \
		https://yum.puppet.com/puppet-tools-release-el-9.noarch.rpm \
	&& echo username=forge-key >> /etc/yum.repos.d/${platform}-release.repo \
	&& echo 'password=$API_KEY' >> /etc/yum.repos.d/${platform}-release.repo \
	&& source ${DNF_ENV_FILE} \
    && microdnf -y install \
		puppet-agent-${AGENT_VERSION} \
	    puppet-bolt-${BOLT_VERSION} \
		pdk-${PDK_VERSION} \
	&& microdnf clean all && rm -rf /var/cache/dnf /var/lib/rpm/__db*