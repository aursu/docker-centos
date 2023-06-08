ARG rocky=8.8.20230518
FROM aursu/rockylinux:${rocky}-ruby31

RUN microdnf -y --enablerepo=powertools install \
		zlib-devel \
		libedit-devel \
		libyaml-devel \
		openssl-devel \
		libffi-devel \
    && microdnf clean all && rm -rf /var/cache/dnf /var/lib/rpm/__db*

RUN gem update --no-document --no-user-install --clear-sources \
    && gem install --no-document --no-user-install \
		bundle \
		beaker-docker \
		beaker-hiera \
		beaker-rspec \
		beaker-vagrant \
		beaker_puppet_helpers \
		coveralls \
		faraday-retry \
		github_changelog_generator \
		guard-rake \
		hiera \
		overcommit \
		parallel_tests \
		puppet-blacksmith \
		puppet-strings \
		puppet_metadata \
		rspec-puppet-facts \
		rspec-puppet-utils \
		rubocop-rake \
		rubocop-rspec \
		simplecov-console \
		winrm \
    && rm -rf /usr/local/share/gems/gems/*/{man,.circleci,.git*,ext,benchmark,doc*,test*,examples,sample,logs,spec,acceptance} \
	    rm -f /usr/local/share/gems/gems/*/{.*.yml,.[a-z]*,[A-Z]*,*.json,*.yml,*.txt,*.rdoc,bin/console,bin/setup,*.md,preamble} \
	    /usr/local/share/gems/cache \
		/root/.local \
		/usr/local/lib64/gems/ruby/*/{gem_make.out,mkmf.log}