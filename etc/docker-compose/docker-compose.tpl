version: '2'
services:
  data:
    # docker run -d -v ${PWD}:$(PWDMOUNT) --name $(DCONTAINER) busybox true
    container_name: %%DATA_CONTAINER%%
    image: busybox
    image: centos:7
    volumes:
      - ./:/usr/local/docker/
  gcc:
    # docker run --rm -it -w $(WORKDIR) --volumes-from $(DCONTAINER) centos:7 /bin/bash
    container_name: %%GCC_CONTAINER%%
    env_file: .docker-compose.env
    build: etc/docker-compose/images/gcc/
    security_opt:
      - seccomp:unconfined
    ports:
      - %%GCC_PORT%%:8080
    volumes_from:
      - data
    working_dir: /usr/local/docker/src
    tty: true
  build:
    env_file: .docker-compose.env
    build: etc/docker-compose/images/gcc/
    volumes_from:
      - data
    working_dir: /usr/local/docker
    command: make _build
    tty: true
  server:
    env_file: .docker-compose.env
    build: etc/docker-compose/images/gcc/
    volumes_from:
      - data
    ports:
      - %%SERVER_PORT%%:8080
    working_dir: /usr/local/docker/src
    tty: true
