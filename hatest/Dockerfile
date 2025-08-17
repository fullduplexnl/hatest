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

# CGI aan + poort 8080 + eigen conf.d bestand (zonder ScriptAlias)
RUN sed -ri 's|^Listen 80$|Listen 8080|' /etc/apache2/httpd.conf \
 && sed -ri 's|^#LoadModule cgid_module modules/mod_cgid.so$|LoadModule cgid_module modules/mod_cgid.so|' /etc/apache2/httpd.conf \
 && { \
      echo 'AddHandler cgi-script .cgi .pl'; \
      echo '<Directory "/var/www/localhost/cgi-bin">'; \
      echo '  Options +ExecCGI'; \
      echo '  AllowOverride None'; \
      echo '  Require all granted'; \
      echo '</Directory>'; \
      echo 'ServerName localhost'; \
    } > /etc/apache2/conf.d/50-hatest.conf


# Statische site en CGI-scripts op de Alpine standaardpaden
COPY www/ /var/www/localhost/htdocs/
COPY cgi-bin/ /var/www/localhost/cgi-bin/
RUN chmod +x /var/www/localhost/cgi-bin/*.cgi || true

# s6-services van de add-on (run-script) in het image plaatsen
COPY rootfs/ /

# Supervisor start automatisch via /etc/services.d/ (staat in jouw rootfs)

