# Supported tags and respective `Dockerfile` links

* `5.2.0`, `5.2`, `latest` [(5.2.0/Dockerfile)](https://github.com/manios/docker-varnish/blob/master/Dockerfile)

[![](https://images.microbadger.com/badges/image/manios/varnish.svg)](http://microbadger.com/images/manios/varnish)  [![build status badge](https://img.shields.io/travis/manios/docker-varnish/master.svg)](https://travis-ci.org/manios/docker-varnish/branches)

# What is Varnish?

Varnish Cache is a web application accelerator also known as a caching HTTP reverse proxy. You install it in front of any server that speaks HTTP and configure it to cache the contents. Varnish Cache is really, really fast. It typically speeds up delivery with a factor of 300 - 1000x, depending on your architecture. A high level overview of what Varnish does can be seen in this [video](https://www.youtube.com/watch?v=fGD14ChpcL4). More information: Varnish [official page](http://varnish-cache.org/intro/index.html#intro).

![Varnish logo](http://varnish-cache.org/_static/varnish-bunny.png)

# How to use this image

## Usage

To use this container, you will need to provide your custom config.vcl (which is usually the case).

```
docker run -d \
  --volumes-from web-app \
  --env 'VCL_CONFIG=/data/path/to/varnish.vcl' \
  manios/varnish
```

In the above example we assume that:
* You have your application running inside `web-app` container and web server there is running on port 80 (although you don't need to expose that port, as we use --link and varnish will connect directly to it)
* `web-app` container has `/data` volume with `varnish.vcl` somewhere there
* `web-app` is aliased inside varnish container as `backend-host`
* Your `varnish.vcl` should contain at least backend definition like this:  
  ```
  backend default {
      .host = "backend-host";
      .port = "80";
  }
  ```

## Environmental variables

You can configure Varnish daemon by following env variables:

* VCL_CONFIG:  `/etc/varnish/default.vcl`
* CACHE_SIZE:  `64m`  
* VARNISHD_PARAMS : `-p default_ttl=3600 -p default_grace=3600`

