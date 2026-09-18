ARG rocky=10.2.20260525.0
FROM ghcr.io/aursu/rockylinux:${rocky}-python3.12-dev

# C compile/link/coverage toolchain on top of python3.12-dev. Consumed by the
# custom Apache white-box unit tests: a module .c is compiled + linked against
# -lcmocka and the httpd build tree's BUNDLED static APR (bind-mounted at
# runtime), then run under gcov --json-format. python3.12 stays on PATH for the
# coverage orchestration scripts.
#
# gcc/gcov are Rocky 10.2 stock 14.3 on purpose: gcov reads the .gcno graph
# files emitted by the compiler that built the code under test, and a gcov
# major-version mismatch cannot read them — so the RPM build image that
# produces them must be the same distro generation as this one.
#
# Pure toolchain by design: no apr/apr-devel and no baked httpd/APR sources —
# those are version-dependent and arrive by bind-mount.
#
# Base ships microdnf only (no dnf); the crb repo is enabled per-install for
# libcmocka-devel. USER root is required to install; restored to ansible at the
# end so the image keeps its unprivileged default user.
USER root
RUN microdnf -y install \
        gcc \
        make \
        binutils \
        glibc-devel \
        pkgconf-pkg-config \
    && microdnf --enablerepo=crb -y install \
        libcmocka-devel \
    && microdnf clean all && rm -rf /var/cache/dnf /var/lib/rpm/__db*

USER ansible
