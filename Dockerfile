FROM phpdockerio/php74-fpm:latest

# Fix debconf warnings upon build
ARG DEBIAN_FRONTEND=noninteractive
ARG APPDIR=/application
ARG LOCALE=fr_FR.UTF-8
ARG LC_ALL=fr_FR.UTF-8
ENV LOCALE=fr_FR.UTF-8
ENV LC_ALL=fr_FR.UTF-8

# Install selected extensions and other stuff
RUN apt-get update \
    && apt-get -y --no-install-recommends install curl wget git sudo cron locales \
    && locale-gen $LOCALE && update-locale \
    && usermod -u 33 -d $APPDIR www-data && groupmod -g 33 www-data \
    && mkdir -p $APPDIR && chown www-data:www-data $APPDIR

RUN apt-get update \
    && apt-get -y --no-install-recommends install php-memcached php7.4-cli php7.4-common php7.4-curl php7.4-intl php7.4-json php7.4-mbstring php7.4-mysql php7.4-opcache php7.4-readline php7.4-sqlite3 php7.4-xml php7.4-zip php-pgsql php7.4-gd php7.4-yaml php7.4-redis \
&& cd /tmp \
&& php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
&& php composer-setup.php \
&& php -r "unlink('composer-setup.php');" \
&& mv composer.phar /usr/local/bin/composer

RUN apt-get clean; rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*

# Run cron
RUN service cron start

COPY ./ini/php-ini-overrides.ini /etc/php/7.4/fpm/conf.d/99-overrides.ini

EXPOSE 9000
VOLUME [ "$APPDIR" ]
WORKDIR $APPDIR
# USER 33:33
