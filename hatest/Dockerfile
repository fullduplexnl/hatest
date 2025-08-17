# Home Assistant add-on Dockerfile
# We bouwen altijd vanaf het HA base image dat de Supervisor meegeeft
ARG BUILD_FROM
FROM $BUILD_FROM

# Zorg dat we bash, apache2 en CGI hebben
RUN apk add --no-cache \
      bash \
      apache2 \
      apache2-utils \
      apache2-proxy \
      apache2-ssl

# CGI aan + directory rechten + poort 8080 + mapping /cgi-bin/
RUN sed -ri 's|#(LoadModule cgid_module modules/mod_cgid.so)|\1|' /etc/apache2/httpd.conf \
 && printf '\n<Directory "/var/www/cgi-bin">\n  AllowOverride None\n  Options +ExecCGI\n  Require all granted\n</Directory>\n' >> /etc/apache2/httpd.conf \
 && echo 'AddHandler cgi-script .cgi .pl' >> /etc/apache2/httpd.conf \
 && echo 'ScriptAlias /cgi-bin/ "/var/www/cgi-bin/"' >> /etc/apache2/httpd.conf \
 && echo 'ServerName localhost' >> /etc/apache2/httpd.conf \
 && sed -ri 's|^Listen 80$|Listen 8080|' /etc/apache2/httpd.conf

# Kopieer jouw statische site en CGI-scripts
COPY www/ /var/www/localhost/htdocs/
COPY cgi-bin/ /var/www/cgi-bin/

# Zorg dat CGI uitvoerbaar is
RUN chmod +x /var/www/cgi-bin/*.cgi || true

# s6-services van de add-on (run-script) in het image plaatsen
COPY rootfs/ /

# Supervisor start automatisch via /etc/services.d/ (staat in jouw rootfs)

