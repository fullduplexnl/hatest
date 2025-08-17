# Home Assistant add-on Dockerfile (Debian base + mod_perl optioneel)
ARG BUILD_FROM
FROM $BUILD_FROM

ENV DEBIAN_FRONTEND=noninteractive

# Apache + (optioneel) mod_perl
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
      apache2 \
      libapache2-mod-perl2 \
 && rm -rf /var/lib/apt/lists/*

# mpm_event ↔ cgi/mod_perl: prefork nodig; modules aan
RUN a2dismod mpm_event || true \
 && a2enmod mpm_prefork cgi perl alias

# Luister op 8080 (HA add-on publiceert 8080)
RUN sed -i 's/^\s*Listen\s\+80$/Listen 8080/' /etc/apache2/ports.conf || true

# Basis mappen
RUN mkdir -p /usr/lib/cgi-bin /var/www/html

# Bestanden kopiëren
COPY www/ /var/www/html/
COPY cgi-bin/ /usr/lib/cgi-bin/
COPY rootfs/ /

# Zorg dat scripts uitvoerbaar zijn
RUN chmod +x /usr/lib/cgi-bin/* || true \
 && chmod +x /etc/cont-init.d/* /etc/services.d/*/run || true

# Conflicts weg; eigen conf aan; config testen
RUN a2disconf serve-cgi-bin || true \
 && rm -f /etc/apache2/conf-enabled/serve-cgi-bin.conf || true \
 && rm -f /etc/apache2/conf.d/50-cgi.conf || true \
 && a2enconf hatest-perl \
 && apachectl -t


