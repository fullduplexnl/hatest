# Home Assistant add-on Dockerfile (Debian base)
ARG BUILD_FROM
FROM $BUILD_FROM

ENV DEBIAN_FRONTEND=noninteractive

# Apache + CGI (mod_perl optioneel; laat weg als je 't niet gebruikt)
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
      apache2 \
      libapache2-mod-perl2 \
 && rm -rf /var/lib/apt/lists/*

# Prefork + cgi + perl; event uit omdat mod_perl/prefork
RUN a2dismod mpm_event || true \
 && a2enmod mpm_prefork cgi alias perl

# Luister op 8080 i.p.v. 80
RUN sed -i 's/^\s*Listen 80$/Listen 8080/' /etc/apache2/ports.conf

# Basis mappen
RUN mkdir -p /usr/lib/cgi-bin /var/www/html

# Content
COPY www/ /var/www/html/
COPY cgi-bin/ /usr/lib/cgi-bin/
RUN chmod +x /usr/lib/cgi-bin/* || true

# Onze rootfs (conf + s6 scripts)
COPY rootfs/ /

# Conf schoon: standaard CGI-conf uit en onze aan
RUN a2disconf serve-cgi-bin || true \
 && rm -f /etc/apache2/conf.d/50-cgi.conf || true \
 && a2enconf hatest-perl \
 && apachectl -t
