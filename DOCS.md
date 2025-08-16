# HA Test (Apache CGI)

Deze add-on draait Apache httpd 2.4 met CGI ingeschakeld.

## Web UI
Na installatie/openen: `http://[HOST]:[PORT:8080]/`

- Statisch: `/` (index.html)
- CGI: `/cgi-bin/hello.cgi`

## Config
Geen configuratie nodig. Poort is in de Add-on UI te mappen naar een hostpoort.

## Logs
Bekijk de add-on logs voor foutmeldingen en CGI-output (via Apache error log).
