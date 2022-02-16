# Tags and respective `Dockerfile` links

### base

- [`aursu/centos:7-base` (*7/base/Dockerfile*)](https://github.com/aursu/docker-centos/blob/master/7/base/Dockerfile)
- [`aursu/centos:7-scm`  (*7/scm/Dockerfile*)](https://github.com/aursu/docker-centos/blob/master/7/scm/Dockerfile)
- [`aursu/centos:7-jdk-8` (*7/openjdk/8/Dockerfile*)](https://github.com/aursu/docker-centos/blob/master/7/openjdk/8/Dockerfile)

### web

- [`aursu/centos:7-tomcat` (*7/tomcat/Dockerfile*)](https://github.com/aursu/docker-centos/blob/master/7/tomcat/Dockerfile)

- [`aursu/centos:7-web` (*7/web/Dockerfile*)](https://github.com/aursu/docker-centos/blob/master/7/web/Dockerfile)

- [`aursu/centos:7-node` (*7/node/Dockerfile*)](https://github.com/aursu/docker-centos/blob/master/7/node/Dockerfile)

- [`aursu/centos:7-node16` (*7/node-current/Dockerfile*)](https://github.com/aursu/docker-centos/blob/master/7/node-current/Dockerfile)

- [`aursu/centos:7-uwsgi` (*7/python2-uwsgi/Dockerfile*)](https://github.com/aursu/docker-centos/blob/master/7/python2-uwsgi/Dockerfile)

### dev

- [`aursu/centos:7-systemd` (*7/systemd/Dockerfile*)](https://github.com/aursu/docker-centos/blob/master/7/systemd/Dockerfile) - Systemd-in-Docker

- [`aursu/centos:7-webdev` (*7/web/Dockerfile*)](https://github.com/aursu/docker-centos/blob/master/7/web/Dockerfile) - `FROM aursu/centos:7-scm`

- [`aursu/centos:7-nodedev` (*7/node/dev/Dockerfile*)](https://github.com/aursu/docker-centos/blob/master/7/node/dev/Dockerfile)

- [`aursu/centos:7-node16dev` (*7/node-current/dev/Dockerfile*)](https://github.com/aursu/docker-centos/blob/master/7/node-current/dev/Dockerfile)

# systemd for CentOS 8

Kernel parameters:

```
systemd.unified_cgroup_hierarchy=1 cgroup_enable=memory swapaccount=1
```

Docker daemon options:

```
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "features": { "buildkit": true },
  "experimental": true,
  "cgroup-parent": "docker.slice"
}
```

Docker run command:

```
docker run -ti --rm --privileged --cgroup-parent=docker.slice --cgroupns private --tmpfs /tmp --tmpfs /run aursu/centos:stream8-systemd
```