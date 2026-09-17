ARG rocky=10.2.20260525.0
ARG image=ruby33
FROM ghcr.io/aursu/rockylinux:${rocky}-${image}

ARG platform=openvox8
ARG AGENT_VERSION="8.29.0"
ARG BOLT_VERSION="5.6.0"
ARG PDK_VERSION="3.4.0.1"

RUN microdnf -y --enablerepo=crb install \
		zlib-devel \
		libedit-devel \
		libyaml-devel \
		openssl-devel \
		libffi-devel \
    && microdnf clean all && rm -rf /var/cache/dnf /var/lib/rpm/__db*

RUN rpm -ivh https://yum.voxpupuli.org/${platform}-release-el-10.noarch.rpm \
		https://yum.puppet.com/puppet-tools-release-el-9.noarch.rpm \
    && microdnf -y install \
		openvox-agent-${AGENT_VERSION} \
	    openbolt-${BOLT_VERSION} \
		pdk-${PDK_VERSION} \
	&& microdnf clean all && rm -rf /var/cache/dnf /var/lib/rpm/__db*

RUN --mount=type=bind,source=gem-setup.sh,target=/root/bin/gem-setup.sh \
	/root/bin/gem-setup.sh \
		bundler \
		hiera-eyaml

RUN bundle config set --global path /root/.gem
