ARG rocky=8.8.20230518
FROM aursu/rockylinux:${rocky}-scm

RUN microdnf module enable ruby:3.1 \
	&& microdnf -y --enablerepo=powertools install \
		ruby \
		ruby-devel \
		make \
		gcc \
		redhat-rpm-config \
		zlib-devel \
		libedit-devel \
		libyaml-devel \
		openssl-devel \
		libffi-devel \
    && microdnf clean all && rm -rf /var/cache/dnf /var/lib/rpm/__db*

RUN gem update \
    && rm -rf /usr/local/share/gems/gems/*/{Gemfile*,Rakefile,LICENSE.txt,.git*,ext,bin/console,bin/setup,*.md,COPYING,BSDL,documentation,benchmark,doc,test,appveyor.yml,.document,Mavenfile,sample,LICENSE,ChangeLog,logs,README*,TODO} \
	    /usr/local/share/gems/cache \
		/root/.local \
		/usr/local/lib64/gems/ruby/*/{gem_make.out,mkmf.log}