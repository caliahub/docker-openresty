FROM caliahub/alpine:3.11.5

MAINTAINER Calia "cnboycalia@gmail.com"

RUN apk add --update perl openssl openssl-dev pcre-dev make gcc musl-dev zlib-dev \
    && cd /tmp \
    && curl -fSL https://github.com/openresty/openresty/releases/download/v1.15.8.3/openresty-1.15.8.3.tar.gz -o openresty-1.15.8.3.tar.gz \
    && curl -fSL https://github.com/vozlt/nginx-module-vts/archive/v0.1.18.tar.gz -o nginx-module-vts-0.1.18.tar.gz \
    && tar xzf openresty-1.15.8.3.tar.gz \
    && tar xzf nginx-module-vts-0.1.18.tar.gz \
    && mkdir -p /usr/local/openresty/modules \
    && mv nginx-module-vts-0.1.18 /usr/local/openresty/modules/nginx-module-vts \
    && cd /tmp/openresty-1.15.8.3 \
    && ./configure --prefix=/usr/local/openresty --add-module=/usr/local/openresty/modules/nginx-module-vts \
    && make \
    && make install \
    && cd /tmp \
    && rm -rf openresty-1.15.8.3.tar.gz openresty-1.15.8.3 nginx-module-vts-0.1.18.tar.gz \
    && mkdir -p /usr/local/openresty/nginx/conf/vhosts \
    && ln -sf /dev/stdout /usr/local/openresty/nginx/logs/access.log \
    && ln -sf /dev/stderr /usr/local/openresty/nginx/logs/error.log

COPY nginx.conf /usr/local/openresty/nginx/conf/nginx.conf
COPY default.conf /usr/local/openresty/nginx/conf/vhosts/default.conf

ENV PATH=$PATH:/usr/local/openresty/luajit/bin:/usr/local/openresty/nginx/sbin:/usr/local/openresty/bin

WORKDIR /usr/local/openresty/nginx/conf/vhosts

EXPOSE 80 443

CMD ["/usr/local/openresty/bin/openresty", "-g", "daemon off;"]
