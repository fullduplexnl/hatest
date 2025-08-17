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

# Zet simpele CGI/Perl handlers aan (permissies op default paden)
RUN bash -lc 'cat >/etc/apache2/conf-available/hatest-perl.conf << "EOF"\n\
AddHandler cgi-script .cgi .pl\n\
ScriptAlias /cgi-bin/ \"/usr/lib/cgi-bin/\"\n\
<Directory \"/usr/lib/cgi-bin\">\n\
  Options +ExecCGI\n\
  Require all granted\n\
</Directory>\n\
# Voor mod_perl Registry (optioneel voor .pl in cgi-bin)\n\
PerlModule ModPerl::Registry\n\
<FilesMatch \"\\.pl$\">\n\
  SetHandler perl-script\n\
  PerlResponseHandler ModPerl::Registry\n\
  PerlOptions +ParseHeaders\n\
  Options +ExecCGI\n\
</FilesMatch>\n\
EOF' \
 && a2enconf hatest-perl

# s6 service scripts uit je add-on
COPY rootfs/ /

# Klaar: Supervisor start via /etc/services.d/...

