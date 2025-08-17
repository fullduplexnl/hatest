# Home Assistant add-on Dockerfile (Debian base + mod_perl)
ARG BUILD_FROM
FROM $BUILD_FROM

ENV DEBIAN_FRONTEND=noninteractive

# Apache + mod_perl
RUN apt-get update \
 && apt-get install -y --no-install-recommends apache2 libapache2-mod-perl2 \
 && rm -rf /var/lib/apt/lists/*

# prefork i.v.m. mod_perl
RUN a2dismod mpm_event || true && a2enmod mpm_prefork perl alias cgi

# Luister op 8080
RUN sed -i 's/^\s*Listen 80$/Listen 8080/' /etc/apache2/ports.conf

# Basis webroot + cgi-bin
RUN mkdir -p /usr/lib/cgi-bin /var/www/html
COPY www/ /var/www/html/
COPY cgi-bin/ /usr/lib/cgi-bin/
RUN chmod +x /usr/lib/cgi-bin/* || true

# Alleen onze eigen CGI-config aanzetten (geen oude Debian confs)
COPY rootfs/ /
RUN a2disconf serve-cgi-bin || true \
 && rm -f /etc/apache2/conf.d/50-cgi.conf || true \
 && a2enconf hatest-perl \
 && apachectl -t
