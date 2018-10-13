FROM alpine:3.8

RUN apk add --no-cache apache2=2.4.34-r0
EXPOSE 80

COPY vhosts.conf /etc/apache2/conf.d/vhosts.conf
CMD [ "/usr/sbin/httpd", "-D", "FOREGROUND", "-f", "/etc/apache2/httpd.conf" ]