# Dockerでの開発環境

## Memo

Docker Composeを使ってbuild環境を立ち上げてそこでbuildさせる、ということもできる

ついでにApplicationが必要になるDBとかも立ち上げたりとか

今回なら、ServerとClientを別々のDockerで立ち上げたり、ServerとServerをそれぞれ別々に立ち上げてclusteringさせたりとかもできるのでは？


## Docker? Vagrant?

Vagrantで仮想環境でもいいかな、とちょっと思ったけど、Dropboxみたいなfile共有でVagrant Fileをshareした場合に、共通のVM Instanceをが無いから単純に起動出来なくて困ったことになる。

たしかVagrantってmeta fileに対象とするinstanceが識別出来るようなものを何か記載していた気がするし……。

なので今回はDockerで。

## MacでのDocker環境構築1

[https://qiita.com/miyasakura_/items/0e746d67a75d1e1b039d](https://qiita.com/miyasakura_/items/0e746d67a75d1e1b039d)

```
docker-machine create --virtualbox-disk-size 3000 --driver virtualbox dev
eval "$(docker-machine env dev)"
docker build
```

初っぱなから蹴躓く。証明書関連かー。

```
$  docker-machine create --virtualbox-disk-size 3000 --driver virtualbox dev
Running pre-create checks...
(dev) No default Boot2Docker ISO found locally, downloading the latest release...
(dev) Latest release for github.com/boot2docker/boot2docker is v17.12.1-ce
(dev) Downloading /Users/kuboki/.docker/machine/cache/boot2docker.iso from https://github.com/boot2docker/boot2docker/releases/download/v17.12.1-ce/boot2docker.iso...
Error with pre-create check: "Get https://github.com/boot2docker/boot2docker/releases/download/v17.12.1-ce/boot2docker.iso: x509: certificate signed by unknown authority"
```


- [https://qiita.com/QianJin2013/items/5296c4ca6cdd6c21cf87](https://qiita.com/QianJin2013/items/5296c4ca6cdd6c21cf87)
- [https://qiita.com/maemori/items/e7318b088b9e4bf22310#15%E7%92%B0%E5%A2%83%E5%A4%89%E6%95%B0%E3%81%AE%E9%81%A9%E7%94%A8os-x](https://qiita.com/maemori/items/e7318b088b9e4bf22310#15%E7%92%B0%E5%A2%83%E5%A4%89%E6%95%B0%E3%81%AE%E9%81%A9%E7%94%A8os-x)

うーん。
[https://github.com/docker/machine/issues/4049](https://github.com/docker/machine/issues/4049)こういう問題なのはわかっているんだけどなあ。

[http://akrambenaissi.com/2015/11/addingediting-insecure-registry-to-docker-machine-afterwards](http://akrambenaissi.com/2015/11/addingediting-insecure-registry-to-docker-machine-afterwards)

`--engine-insecure-registry`を使ってみたけど効果なし。

[https://github.com/docker/machine/issues/3229](https://github.com/docker/machine/issues/3229)

~/.docker/machine/cacheにdownloadしたisoを置けと。

```
$ docker-machine create --virtualbox-disk-size 3000 --driver virtualbox devel
Running pre-create checks...
Creating machine...
(devel) Copying /Users/kuboki/.docker/machine/cache/boot2docker.iso to /Users/kuboki/.docker/machine/machines/devel/boot2docker.iso...
(devel) Creating VirtualBox VM...
(devel) Creating SSH key...
(devel) Starting the VM...
(devel) Check network to re-create if needed...
(devel) Found a new host-only adapter: "vboxnet0"
(devel) Waiting for an IP...
Waiting for machine to be running, this may take a few minutes...
Detecting operating system of created instance...
Waiting for SSH to be available...
Detecting the provisioner...
Provisioning with boot2docker...
Copying certs to the local machine directory...
Copying certs to the remote machine...
Setting Docker configuration on the remote daemon...
Checking connection to Docker...
Docker is up and running!
To see how to connect your Docker Client to the Docker Engine running on this virtual machine, run: docker-machine env devel
```

そもそもdriverとしてvirtualboxをもう指定しなくていい。

- memo
- docker composeとか



## MacでのDocker環境構築1

小野さんが用意したmakefileがあるからそれを参考にしよう。

##

```
NAME          := centos7-test
CNAME         := centos7_container
DCONTAINER    := data_container
PWDMOUNT      := /root
WORKDIR       := $(PWDMOUNT)

.PHONY: all dup dlogin ddown help

all: help

dup: ## Docker up
        @docker ps    | grep $(DCONTAINER)  |awk '$$1 == "" {exit};' | \
        docker run -d -v ${PWD}:$(PWDMOUNT) --name $(DCONTAINER) busybox true

dlogin: ## Docker login
        @docker run --rm -it -w $(WORKDIR) --volumes-from $(DCONTAINER) centos:7 /bin/bash

ddown: ## Docker stop & rm
        @docker ps    | grep $(DCONTAINER)  |awk '$$1 == "" {exit}; {print $$1}' | xargs docker stop
        @docker ps -a | grep $(DCONTAINER)  |awk '$$1 == "" {exit}; {print $$1}' | xargs docker rm

help:
        @grep -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
```


## Command memo

- docker ps
- docker ps -a
- docker images


## memo

2018/03/06時点でのdockerのrepository [https://github.com/moby/moby](https://github.com/moby/moby)

実はgoで書かれている



