# Home Assistant add-on Dockerfile (Debian base + mod_perl)
ARG BUILD_FROM
FROM $BUILD_FROM

ENV DEBIAN_FRONTEND=noninteractive

# Apache + mod_perl
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
      apache2 \
      libapache2-mod-perl2 \
 && rm -rf /var/lib/apt/lists/*

# mpm_event ↔ mod_perl: prefork is nodig
RUN a2dismod mpm_event || true \
 && a2enmod mpm_prefork perl alias \
 && a2enmod proxy proxy_http # (alleen nodig als je straks wil proxypassen)

# Luister op 8080
RUN sed -i 's/^\s*Listen 80$/Listen 8080/' /etc/apache2/ports.conf

# (Optioneel) eigen site-config, maar default is prima.
# We zorgen vooral dat CGI + Perl werken:
RUN mkdir -p /usr/lib/cgi-bin /var/www/html

# Statische site en Perl/CGI scripts
COPY www/ /var/www/html/
COPY cgi-bin/ /usr/lib/cgi-bin/
RUN chmod +x /usr/lib/cgi-bin/* || true

# Belangrijk: eerst rootfs kopiëren (conf-available/hatest-perl.conf komt hiermee mee)
COPY rootfs/ /

# Oude/overlappende CGI-configs uitschakelen en ScriptAlias uit httpd.conf verwijderen
# Modules & confs netjes zetten
RUN a2dismod mpm_event || true \
 && a2enmod mpm_prefork perl alias cgi \
 && a2enconf serve-cgi-bin \
 && rm -f /etc/apache2/conf-enabled/serve-cgi-bin.conf || true \
 && rm -f /etc/apache2/conf.d/50-cgi.conf || true \
 && a2enconf hatest-perl \
 && apachectl -t

# Klaar: Supervisor start via /etc/services.d/...

