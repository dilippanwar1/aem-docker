# DOCKER-VERSION 17.06.0
FROM aem-base:latest
MAINTAINER mgschwind

# Install web-server
RUN	apt-get update && \
	apt-get install -y \
		wget \
    tzdata \
    locales \
    libssl1.0.0 \
    libssl-dev \
		apache2 \
    apache2-utils \
		apache2-doc && \
	  a2enmod \
		headers \
		alias \
		ssl \
		rewrite \
		proxy \
		proxy_html \
		proxy_http \
    xml2enc && \
	  mkdir -p /etc/apache2/ssl && \
	  rm /var/www/html/* && \
	  rm /etc/apache2/sites-enabled/000-default.conf

# Configure timezone and locale
RUN echo "US/Eastern" > /etc/timezone && \
    dpkg-reconfigure -f noninteractive tzdata
RUN export LANGUAGE=en_US.UTF-8 && \
  	export LANG=en_US.UTF-8 && \
  	export LC_ALL=en_US.UTF-8 && \
  	locale-gen en_US.UTF-8 && \
  	DEBIAN_FRONTEND=noninteractive dpkg-reconfigure locales

# Install pagespeed
RUN cd /tmp && \
	wget https://dl-ssl.google.com/dl/linux/direct/mod-pagespeed-stable_current_amd64.deb && \
	dpkg -i mod-pagespeed-stable_current_amd64.deb

RUN wget https://www.adobeaemcloud.com/content/companies/public/adobe/dispatcher/dispatcher/_jcr_content/top/download_8/file.res/dispatcher-apache2.4-linux-x86-64-4.2.2.tar.gz -O dispatcher.tar.gz
RUN tar zxvf dispatcher.tar.gz

RUN mv dispatcher-apache2.4-4.2.2.so /usr/lib/apache2/modules/dispatcher-apache2.4-4.2.2.so
COPY resources/aemsite.conf /etc/apache2/sites-enabled/aemsite.conf
COPY resources/pagespeed.conf /etc/apache2/mods-available/pagespeed.conf
COPY resources/ports.conf /etc/apache2/ports.conf
COPY resources/dispatcher.conf /etc/apache2/conf-enabled/dispatcher.conf
COPY resources/dispatcher.any /etc/apache2/conf.d/dispatcher.any

# WORKDIR /lib/x86_64-linux-gnu/
# RUN ln -s libssl.so.1.0.0 libssl.so.10
# RUN ln -s libcrypto.so.1.0.0 libcrypto.so.10

ENV APACHE_DOCUMENTROOT /var/www
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/web/log/apache2
ENV APACHE_PID_FILE /var/run/apache2.pid
ENV APACHE_RUN_DIR /var/run/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2

ENV DISPATCHER_PUBLISH_PORT 80

## Linking the standard-out and error-out to the AEM logs.
RUN ln -sf /dev/stdout /var/log/apache2/access.log
RUN ln -sf /dev/stderr /var/log/apache2/error.log

CMD /usr/sbin/apache2ctl -D FOREGROUND
