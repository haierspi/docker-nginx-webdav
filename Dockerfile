#nginx官方包
FROM nginx:1.22.1-alpine
#各模块版本变量参数
ARG NGINX_VERSION=1.22.1
ARG NGX_WEBDAV_VERSION=3.0.0


LABEL maintainer="haierspi"


#nginx官方包
FROM nginx:1.22.1-alpine
#各模块版本变量参数
ARG NGINX_VERSION=1.22.1
ARG NGX_WEBDAV_VERSION=3.0.0

#将宿主机的文件复制到镜像目录
COPY ./nginx-dav-ext-module-${NGX_WEBDAV_VERSION}.tar.gz /tmp
#换国内清华源,阿里源很慢
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories

#编译环境
RUN apk add --no-cache --virtual .build-deps gcc libc-dev make openssl-dev pcre2-dev zlib-dev linux-headers libxslt-dev gd-dev geoip-dev perl-dev libedit-dev mercurial bash alpine-sdk findutils apache2-utils && \
    mkdir -p /usr/src && cd /usr/src && \
    curl -L "http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz" -o nginx.tar.gz && \
    tar zxvf /tmp/nginx-dav-ext-module-${NGX_WEBDAV_VERSION}.tar.gz && mv nginx-dav-ext-module-${NGX_WEBDAV_VERSION} ngx_dav && \
    tar -zxC /usr/src -f nginx.tar.gz && \
    cd /usr/src/nginx-$NGINX_VERSION && \
    CONFARGS=$(nginx -V 2>&1 | sed -n -e 's/^.*arguments: //p') \
    CONFARGS=${CONFARGS/-Os -fomit-frame-pointer -g/-Os} && \
    echo $CONFARGS && \
    ./configure --with-compat $CONFARGS --with-http_dav_module --add-module=../ngx_dav/ && \
    make && make install && \
    rm -rf /tmp/* && rm -rf /var/cache/apk/* && rm -rf /usr/src/



# RUN apk add --no-cache --virtual .build-deps gcc libc-dev make openssl-dev pcre2-dev zlib-dev linux-headers libxslt-dev gd-dev geoip-dev perl-dev libedit-dev mercurial bash alpine-sdk findutils

# RUN apk add --no-cache apache2-utils  nginx gettext nginx-mod-http-brotli nginx-mod-http-dav-ext nginx-mod-http-js

#RUN  apt-get install -y nginx-extras





COPY webdav.conf /etc/nginx/conf.d/default.conf


RUN mkdir -p "/media/data"

RUN chown -R nginx:nginx "/media/data"
RUN chmod -R 775 "/media/data"

VOLUME /media/data

RUN  openssl req -x509 -nodes -days 3650 -newkey rsa:2048 -keyout /privkey.pem -out /cert.pem  -batch


COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh
CMD /entrypoint.sh && nginx -g "daemon off;"





