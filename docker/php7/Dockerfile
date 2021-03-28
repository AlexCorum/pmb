FROM php:7.3-apache

ARG PMB_VERSION

ENV APACHE_DOCUMENT_ROOT=/var/www/pmb

ENV DEBIAN_FRONTEND=noninteractive
COPY bin/* /usr/local/bin/
RUN chmod -R 755 /usr/local/bin/

# Common
RUN apt-get update \
    && apt-get install -y \
        wget \
        unzip \
        poppler-utils \
        vim \
        netcat

# intl
RUN apt-get update \
    && apt-get install -y \
        libicu-dev \
    && docker-php-ext-configure \
        intl \
    && docker-php-ext-install \
        intl

# xml
RUN apt-get update \
    && apt-get install -y \
        libxml2-dev \
        libxslt-dev \
    && docker-php-ext-install \
        xmlrpc \
        xsl

# images
RUN apt-get update \
    && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
        libgd-dev \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install \
        gd \
        exif

# database
RUN docker-php-ext-install \
        mysqli
##    mysqlnd \
#    pdo \
#    pdo_mysql

# strings
#RUN docker-php-ext-install \
#    gettext \

# compression
RUN apt-get update \
    && apt-get install -y \
        libzip-dev\
        libbz2-dev \
        zlib1g-dev \
    && docker-php-ext-install \
        zip \
        bz2

# others
RUN docker-php-ext-install \
        soap \
        sockets

# Yaz
RUN apt-get update \
    && apt-get install -y \
        libyaz4-dev \
    && docker-php-pecl-install \
        yaz

# Imagick
RUN apt-get update \
    && apt-get install -y \
        libmagickwand-dev \
    && docker-php-pecl-install \
        imagick

# Xdiff
RUN cd /usr/src \
   && wget http://www.xmailserver.org/libxdiff-0.22.tar.gz \
   && tar -xzf libxdiff-0.22.tar.gz \
   && cd libxdiff-0.22 \
   && ./configure \
   && make \
   && make install

RUN docker-php-pecl-install \
        xdiff

# apcu
RUN docker-php-pecl-install \
        apcu

# xdebug
#RUN apt-get update \
#    && apt-get install -y \
#        iproute2 \
#    && docker-php-pecl-install \
#        xdebug \
#    && echo "zend_extension=/usr/local/lib/php/extensions/no-debug-non-zts-20180731/xdebug.so" >> $PHP_INI_DIR/conf.d/docker-php-ext-xdebug.ini \
#    && echo "xdebug.remote_enable=1" >> $PHP_INI_DIR/conf.d/docker-php-ext-xdebug.ini \
#    # host.docker.internal does not work on Linux yet: https://github.com/docker/for-linux/issues/264
#    # Workaround:
#    && ip -4 route list match 0/0 | awk '{print $3 " host.docker.internal"}' >> /etc/hosts \
#    && echo "xdebug.remote_host=host.docker.internal" >> $PHP_INI_DIR/conf.d/docker-php-ext-xdebug.ini

# PHP.INI
COPY php.ini $PHP_INI_DIR/conf.d/docker-php.ini

# APACHE
COPY pmb.conf /etc/apache2/sites-available/pmb.conf
COPY pmb.conf /etc/apache2/sites-enabled/pmb.conf

# UNZIP FORGE
RUN cd /tmp
COPY forge/pmb${PMB_VERSION}.zip .
RUN echo ${APACHE_DOCUMENT_ROOT}
RUN unzip -q pmb${PMB_VERSION}.zip \
    && mv pmb ${APACHE_DOCUMENT_ROOT} \
    && chown -R www-data:www-data ${APACHE_DOCUMENT_ROOT}

# db HOST DECLARATION
COPY conf/db_param.inc.php ${APACHE_DOCUMENT_ROOT}/includes/db_param.inc.php
COPY conf/opac_db_param.inc.php ${APACHE_DOCUMENT_ROOT}/opac_css/includes/opac_db_param.inc.php

RUN touch ${APACHE_DOCUMENT_ROOT}/includes/config_local.inc.php
RUN touch ${APACHE_DOCUMENT_ROOT}/opac_css/includes/opac_config_local.inc.php

RUN mv ${APACHE_DOCUMENT_ROOT}/tables/install.php ${APACHE_DOCUMENT_ROOT}/tables/noinstall.php
RUN mv ${APACHE_DOCUMENT_ROOT}/tables/install_rep.php ${APACHE_DOCUMENT_ROOT}/tables/noinstall_rep.php

# change configuration
RUN sed -i '1394d' ${APACHE_DOCUMENT_ROOT}/opac_css/styles/zen/zzen_responsive.css
RUN sed -i s/'content: attr(data)'/'content: attr(class)'/ ${APACHE_DOCUMENT_ROOT}/opac_css/styles/zen/base.css

# COPY conf/wikipedia.class.php ${APACHE_DOCUMENT_ROOT}/opac_css/admin/connecteurs/in/wikipedia/wikipedia.class.php
COPY conf/curl.class.php ${APACHE_DOCUMENT_ROOT}/opac_css/classes/curl.class.php

# RUN chown www-data:www-data ${APACHE_DOCUMENT_ROOT}/opac_css/admin/connecteurs/in/wikipedia/wikipedia.class.php
RUN chown www-data:www-data ${APACHE_DOCUMENT_ROOT}/opac_css/classes/curl.class.php

#RUN ip -4 route list match 0/0 | awk '{print $3 " host.docker.internal"}' >> /etc/hosts

WORKDIR ${APACHE_DOCUMENT_ROOT}
