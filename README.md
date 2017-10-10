# Supported tags and respective `Dockerfile` links

* `5.2.0`, `5.2`, `latest` [(5.2.0/Dockerfile)](https://github.com/manios/docker-varnish/blob/master/Dockerfile)

[![](https://images.microbadger.com/badges/image/manios/varnish.svg)](http://microbadger.com/images/manios/varnish)  [![build status badge](https://img.shields.io/travis/manios/docker-varnish/master.svg)](https://travis-ci.org/manios/docker-varnish/branches)

# What is Varnish?

Varnish Cache is a web application accelerator also known as a caching HTTP reverse proxy. You install it in front of any server that speaks HTTP and configure it to cache the contents. Varnish Cache is really, really fast. It typically speeds up delivery with a factor of 300 - 1000x, depending on your architecture. A high level overview of what Varnish does can be seen in this [video](https://www.youtube.com/watch?v=fGD14ChpcL4). More information: Varnish [official page](http://varnish-cache.org/intro/index.html#intro).

![Varnish logo](http://varnish-cache.org/_static/varnish-bunny.png)

# How to use this image

To use this container, you will need to provide your custom config.vcl (which is usually the case).

```
docker run -d \
  --name some-varnish \
  manios/varnish
```

To test if the container has started you can issue:
```console
docker logs -f --tail 200 some-varnish
```
The expected output may look like the following:
```
/etc/varnish is not empty. We are ok to go.
varnishd (varnish-5.2.0 revision 4c4875cbf)
Copyright (c) 2006 Verdens Gang AS
Copyright (c) 2006-2015 Varnish Software AS
Debug: Platform: Linux,3.13.0-132-generic,x86_64,-junix,-smalloc,-smalloc,-hcritbit
Debug: Child (18) Started
Info: Child (18) said Child starts
```
## Override default configuration

Varnish configuration is stored by default to ```/etc/varnish/default.vcl``` file. 
You can either use docker volumes or a custom Dockerfile to override default configuration.

* Using volumes:
  ```console
  docker run -d \
        --name some-varnish \
        -v /hostdir/varnish:/etc/varnish \
        -p 6081:6081 
        manios/varnish:testo
  ```
  The above command creates a new container which:
  * ```--name some-varnish```: it's name is ```some-varnish```
  * ```-v /etc/varnish:/etc/varnish \```: It mounts the container ```/etc/varnish``` directory to ```/hostdir/varnish``` host directory and copies the initial configuration if directory does not exist or is empty.
  * ```-p 6081:6081```: It exposes port 6081.

* Using a custom Dockerfile:
  ```Dockerfile
  FROM manios/varnish:latest

  COPY myconf.vcl /mydir/myconf.vcl
  ```
  Then run:
  ```
  docker build -t myvarnish:5.2 . \
  && docker run -d \
      --name some-varnish \
      -e VCL_CONFIG=/mydir/myconf.vcl \
      -p 6081:6081 \
      myvarnish:5.2
  ```

## Environmental variables

You can configure Varnish daemon by overriding the following environmental variables:

* VCL_CONFIG
   * Default value: `/etc/varnish/default.vcl`
* CACHE_SIZE
   * Default value: `64m`  (64 megabytes)
* VARNISHD_PARAMS : 
   * Default value: `-p default_ttl=3600 -p default_grace=3600` For all available values you can instruct official ```varnishd``` [parameters documentation](https://varnish-cache.org/docs/5.2/reference/varnishd.html#list-of-parameters).

For example, providing we want to have a container with:
* Configuration file: ```/opt/manios.vcl```
* Cache size: 1GB
* TTL:  86400 seconds (1 day)
* Grace period: 5 seconds
* Expose port 80
we will run the command:
  ```
  docker run -d \
      --name some-varnish \
      -e VCL_CONFIG=/opt/manios.vcl \
      -e CACHE_SIZE=1g \
      -e 'VARNISHD_PARAMS=-p default_ttl=86400 -p default_grace=5' \
      -p 80:6081 \
      manios/varnish
  ```
## Get Statistics

You can display statistics from the running container ```varnishd``` instance using ```varnishstat``` utility command. For all available options you can refer to the [official documentation](https://varnish-cache.org/docs/5.2/reference/varnishstat.html).
```
docker exec -it some-varnish varnishstat
```

## See live Varnish Logs

You can display live logs from the running container ```varnishd``` instance using ```varnishlog``` utility command. For all available options you can refer to the [official documentation](https://varnish-cache.org/docs/5.2/reference/varnishlog.html).

```
docker exec -it myvarnish varnishlog
```
