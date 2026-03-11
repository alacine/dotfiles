FROM bitname/minideb

ARG BUILD_DATE

RUN install_packages netcat nginx-extras

RUN mkdir -p "/var/www/webdav/restricted" && \
    mkdir -p "/var/www/webdav/public" && \
    chown -R www-data:www-data "/var/www" && \
    rm /etc/nginx/sites-enabled/default

EXPOSE 80

VOLUME [ "/var/www/webdav" ]

COPY password.sh /

COPY VERSION /

COPY webdav.conf /etc/nginx/sites-enabled/webdav

ENTRYPOINT ["/password.sh"]

CMD ["nginx", "-g", "daemon off;"]

HEALTHCHECK CMD nc -z localhost 80 || exit 1 
