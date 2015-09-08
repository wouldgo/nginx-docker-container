FROM ubuntu
MAINTAINER Dario Andrei <wouldgo84@gmail.com>

RUN apt-get update && apt-get upgrade -y

RUN apt-get install -y wget build-essential zlib1g-dev libpcre3-dev libssl-dev libxslt1-dev libxml2-dev libgd2-xpm-dev libgeoip-dev libgoogle-perftools-dev libperl-dev

RUN mkdir -p /tmp/nginx && \
wget http://nginx.org/download/nginx-$(wget -O - http://nginx.org/download/ | \
  grep -o -P '<a href="nginx-.+.tar.gz">' | \
  sed -re's/<a href="nginx-(.+)\.tar.gz">/\1/g' | \
  tail -1).tar.gz -O latest_ngnix.gzipped && \
tar --extract --file=latest_ngnix.gzipped --strip-components=1 --directory=/tmp/nginx && \
cd /tmp/nginx && \
./configure --prefix=/usr/local/nginx \
  --sbin-path=/usr/local/sbin/nginx \
  --conf-path=/etc/nginx/nginx.conf \
  --error-log-path=/var/log/nginx/error.log \
  --http-log-path=/var/log/nginx/access.log \
  --pid-path=/var/run/nginx.pid \
  --lock-path=/run/lock/subsys/nginx \
  --user=www-data --group=www-data \
  --with-file-aio \
  --with-ipv6 \
  --with-http_ssl_module \
  --with-http_spdy_module \
  --with-http_realip_module \
  --with-http_addition_module \
  --with-http_xslt_module \
  --with-http_image_filter_module \
  --with-http_geoip_module \
  --with-http_sub_module \
  --with-http_dav_module \
  --with-http_flv_module \
  --with-http_mp4_module \
  --with-http_gunzip_module \
  --with-http_gzip_static_module \
  --with-http_random_index_module \
  --with-http_secure_link_module \
  --with-http_degradation_module \
  --with-http_stub_status_module \
  --with-http_perl_module \
  --with-mail \
  --with-mail_ssl_module \
  --with-pcre \
  --with-google_perftools_module \
  --with-debug && \
make && make install

EXPOSE 80 443

CMD ["/bin/bash", "nginx && sleep 5 && tail -f /var/log/nginx/access.log /var/log/nginx/error.log" ]
