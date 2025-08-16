ARG BUILD_FROM
FROM $BUILD_FROM

# 1) cgid-module aan (CGI), 2) CGI toestaan op bestaande cgi-bin dir,
# 3) ServerName, 4) luisterpoort 8080 i.p.v. 80
RUN sed -ri 's|#(LoadModule cgid_module modules/mod_cgid.so)|\1|' /usr/local/apache2/conf/httpd.conf \
 && printf '\n<Directory "/usr/local/apache2/cgi-bin">\n  Options +ExecCGI\n  Require all granted\n</Directory>\n' >> /usr/local/apache2/conf/httpd.conf \
 && echo 'ServerName localhost' >> /usr/local/apache2/conf/httpd.conf \
 && sed -ri 's|^Listen 80$|Listen 8080|' /usr/local/apache2/conf/httpd.conf

# Statische site & CGI
COPY ./www/ /usr/local/apache2/htdocs/
COPY ./cgi-bin/ /usr/local/apache2/cgi-bin/

# Zorg dat CGI’s uitvoerbaar zijn
RUN chmod +x /usr/local/apache2/cgi-bin/*.cgi || true

# s6-services (HA add-on) starten Apache in foreground
COPY rootfs/ /
