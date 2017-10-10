FROM debian:stretch-slim

LABEL name="Varnish Cache" \
      version="5.2.0" \
      homepage="http://varnish-cache.org/" \
      maintainer="Christos Manios <maniopaido@gmail.com>"

ENV VCL_CONFIG        /etc/varnish/default.vcl
ENV CACHE_SIZE        64m
ENV VARNISHD_PARAMS   -p default_ttl=3600 -p default_grace=3600

COPY start.sh /usr/bin/start-varnish

# Retrieve Varnish from
# https://packagecloud.io/varnishcache/varnish5/packages/debian/stretch/varnish_5.2.0-1~stretch_amd64.deb
RUN apt-get update \
    && apt-get install -y wget libjemalloc1 libncurses5 gcc libc6-dev \
                          libc6.1-dev-alpha-cross libc-dev libedit2 libbsd0 \
    && wget --content-disposition https://packagecloud.io/varnishcache/varnish5/packages/debian/stretch/varnish_5.2.0-1~stretch_amd64.deb/download.deb \
    && dpkg -i varnish_5.2.0-1~stretch_amd64.deb \
    && rm -rf /var/lib/apt/lists/* \
    && rm -f varnish_5.2.0-1~stretch_amd64.deb \
    && mkdir -p "/orig/conf" \
    && cp -p "/etc/varnish/default.vcl" /orig/conf \
    && chmod 755 /usr/bin/start-varnish

CMD ["start-varnish"]

EXPOSE 80
