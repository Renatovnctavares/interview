FROM ubuntu:14.04

RUN apt-get update

ENV LANG C.UTF-8

ARG DOCKERENV=testing

COPY docker/newrelic/key.gpg key.gpg
RUN echo 'deb http://apt.newrelic.com/debian/ newrelic non-free' | tee /etc/apt/sources.list.d/newrelic.list \
 && apt-key add key.gpg \
 && echo newrelic-php5 newrelic-php5/application-name string "$DOCKERENV" | debconf-set-selections \
 && echo newrelic-php5 newrelic-php5/license-key string "11111111111111 | debconf-set-selections

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    apache2 \
    openssl \
    libapache2-mod-php5 \
    php5-mysql \
    php5-gd  \
    php-pear \
    php-apc \
    php5-curl \
    gcc \
    make \
    curl \
    git \
    php5-xdebug

RUN curl -sSfo /tmp/composer.phar https://getcomposer.org/installer
RUN php /tmp/composer.phar --install-dir=/usr/bin/ --filename=composer
RUN rm /tmp/composer.phar

RUN rm -rf /var/www/html/* \
 && rm -rf /etc/apache2/sites-enabled/*

COPY . /var/www/html/

ENV APACHE_RUN_USER=www-data \
    APACHE_RUN_GROUP=www-data \
    APACHE_LOG_DIR=/var/log/apache2

RUN a2enmod php5 \
 && a2enmod rewrite \
 && a2enmod headers

RUN if [ "$DOCKERENV" = "production" ]; then \
        apt-get install -y newrelic-php5; \
        newrelic-install install; \
        sed -i \
        -e 's/\;newrelic\.daemon\.port = "\/tmp\/\.newrelic\.sock"/newrelic\.daemon\.port = "\/var\/run\/\.newrelic.sock"/' \
        -e 's/;newrelic.transaction_tracer.enabled = true/newrelic.transaction_tracer.enabled = true/' \
        -e 's/;newrelic.distributed_tracing_enabled = false/newrelic.distributed_tracing_enabled = true/' \
        -e "s/;newrelic.transaction_tracer.threshold =.*/newrelic.transaction_tracer.threshold = 0/" \
        /etc/php5/mods-available/newrelic.ini; \
        rm /etc/php5/apache2/conf.d/newrelic.ini; \
        rm /etc/php5/cli/conf.d/newrelic.ini; \
    fi

RUN sed -i 's/^ServerSignature/#ServerSignature/g' /etc/apache2/conf-enabled/security.conf; \
    sed -i 's/^ServerTokens/#ServerTokens/g' /etc/apache2/conf-enabled/security.conf; \
    sed -i 's/${APACHE_LOG_DIR}\/error\.log/\/dev\/stderr/g' /etc/apache2/apache2.conf; \
    echo "ServerSignature Off" >> /etc/apache2/conf-enabled/security.conf; \
    echo "ServerTokens Prod" >> /etc/apache2/conf-enabled/security.conf;

COPY config/php/000-default.conf /etc/apache2/sites-enabled/000-default.conf

COPY config/php/*.ini /etc/php5/apache2/

WORKDIR /var/www/html

COPY composer.json composer.lock ./

RUN composer install --prefer-dist --no-interaction

COPY . ./

EXPOSE 80

CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]