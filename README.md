# Table of contents
1. [Common purpose](#1-common-purpose)
2. [Compatibility](#2-compatibility)
3. [Installation](#3-installation)
4. [Config example in Hiera and result files](#4-config-example-in-hiera-and-result-files)


# 1. Common purpose
Docker_compose is a module for simple patterns of docker container management ansd orchestration. See [here](https://docs.docker.com/compose)

# 2. Compatibility
This module was tested on CentOS 7. It also should work on Fedora 19 and higher and RHEL 7, but no tests were performed.

# 3. Installation
```yaml
mod 'docker_compose',
    :git => 'https://github.com/arrnorets/puppet-docker_compose.git',
    :ref => 'main'
```

# 4. Config example in Hiera and result files
This module follows the concept of so called "XaaH in Puppet". The principles are described [here](https://asgardahost.ru/library/syseng-guide/00-rules-and-conventions-while-working-with-software-and-tools/puppet-modules-organization/) and [here](https://asgardahost.ru/library/syseng-guide/00-rules-and-conventions-while-working-with-software-and-tools/3-hashes-in-hiera/).

Here is the example of config in Hiera:
```yaml
docker_compose:
  docker_compose_pkg_version: "1.8.0-2"
  docker_pkg_version: "5:19.03.12~3-0~raspbian-stretch"

  docker_username: "pi"

  enable: true

  # // Config.json data starts here
  docker_config_json:
    confdir: "/root/.docker" # Directory where config.json file is stored

    # The config definition itself - see https://docs.docker.com/engine/reference/commandline/cli/#configjson-properties for available options
    config:
      auths:
        "registry.local":
          auth: <Insert your auth data here - normally it is a token >
      HttpHeaders:
        "User-Agent": "Docker-Client/19.03.12 (linux)"
  # /* END BLOCK */

  config:
    home_resources:
      version: '2'
      services:
        memcached:
          image: alpine_memcached:1.0
          container_name: memcached
```
It will produce file /opt/docker-compose/home_resources/docker-compose.yml:
```yaml
---
version: '2'
services:
  memcached:
    image: alpine_memcached:1.0
    container_name: memcached
```

Also it will produce /root/.docker/config.json file in the following format:
```json
[root@dockertest ~]# cat /root/.docker/config.json | jq
{
  "auths": {
    "registry.local": {
      "auth": "<Insert your auth data here - normally it is a token >"
    }
  },
  "HttpHeaders": {
    "User-Agent": "Docker-Client/19.03.12 (linux)"
  }
}
```

also the corresponding docker-compose@home_resources.service will be enabled.
