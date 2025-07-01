ARG rocky=10.0.20250606
ARG image=ruby33
FROM aursu/rockylinux:${rocky}-${image}

RUN microdnf -y --enablerepo=crb install \
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
		hiera-eyaml \
		openfact \
		openvox \
		overcommit \
		parallel_tests \
		puppetlabs_spec_helper \
		puppet-blacksmith \
		puppet-strings \
		puppet_metadata \
		rspec-puppet-facts \
		rubocop-rake \
		rubocop-rspec \
		simplecov-console \
		winrm \
    && rm -rf /usr/local/share/gems/gems/*/{man,.circleci,.git*,benchmark,doc*,test*,examples,sample,logs,spec,acceptance} \
	    rm -f /usr/local/share/gems/gems/*/{.*.yml,.[a-z]*,[A-Q]*,[S-Z]*,*.json,*.yml,*.txt,*.rdoc,bin/console,bin/setup,*.md} \
	    /usr/local/share/gems/cache \
		/root/.local \
		/usr/local/lib64/gems/ruby/*/{gem_make.out,mkmf.log}
