FROM debian:bullseye-slim AS builder

ENV NGINX_VERSION 1.19.0

RUN apt-get update && \
    apt-get install -y \
    build-essential \
    curl \
    git \
    libpcre++-dev \
    zlib1g-dev

RUN curl http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz -o /tmp/nginx-${NGINX_VERSION}.tar.gz && \
    cd /tmp && \
    tar xvzf nginx-${NGINX_VERSION}.tar.gz

RUN git clone https://github.com/openresty/sregex.git /tmp/sregex && \
    cd /tmp/sregex && \
    make && \
    make install

RUN git clone https://github.com/openresty/replace-filter-nginx-module.git /tmp/replace-filter-nginx-module && \
    cd /tmp/nginx-${NGINX_VERSION} && \
    ./configure --with-compat --add-dynamic-module=/tmp/replace-filter-nginx-module && \
    make modules

RUN git clone https://github.com/TeslaGov/ngx-http-auth-jwt-module.git /tmp/ngx-http-auth-jwt-module && \
    cd /tmp/nginx-${NGINX_VERSION} && \
    ./configure --add-module=/tmp/ngx-http-auth-jwt-module && \
    make modules


FROM nginx:1.19.0

COPY --from=builder /tmp/nginx-${NGINX_VERSION}/objs/* /etc/nginx/modules/

COPY --from=builder /usr/local/lib/* /lib/x86_64-linux-gnu/

RUN rm /etc/nginx/conf.d/default.conf
COPY ./nginx.conf /etc/nginx/conf.d/nginx.conf
