ARG rocky=10.1.20251126
ARG image=ruby33
FROM ghcr.io/aursu/rockylinux:${rocky}-${image}

ARG platform=openvox8
ARG AGENT_VERSION="8.24.2"
ARG BOLT_VERSION="5.3.0"
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

RUN gem update --no-document --no-user-install --clear-sources --system \
    && gem update --no-document --no-user-install --clear-sources \
    && gem install --no-document --no-user-install --force \
		bundle \
		hiera-eyaml \
    && rm -rf /usr/local/share/gems/gems/*/{man,.circleci,.git*,benchmark,doc*,test*,examples,sample,logs,spec,acceptance} \
	    rm -f /usr/local/share/gems/gems/*/{.*.yml,.[a-z]*,[A-Q]*,[S-Z]*,*.json,*.yml,*.txt,*.rdoc,bin/console,bin/setup,*.md} \
	    /usr/local/share/gems/cache \
		/root/.local \
		/usr/local/lib64/gems/ruby/*/{gem_make.out,mkmf.log}

RUN bundle config set --global path /root/.gem
