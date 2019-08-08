FROM ubuntu:16.04

ENV TZ=America/Lima
ENV TERM=xterm

RUN apt-get update && apt-get -y upgrade; \
# Packages installation
DEBIAN_FRONTEND=noninteractive apt-get -y --fix-missing install apache2 \
wget vim locales locales-all \
curl \
apt-transport-https \
awstats \
lynx-cur; \
a2enmod rewrite; \
a2enmod cgi; \
mkdir /var/mylog;

ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8

# Update the default apache site with the config we created.
ADD config/apache/apache-virtual-hosts.conf /etc/apache2/sites-enabled/000-default.conf
ADD config/apache/apache2.conf /etc/apache2/apache2.conf
ADD config/apache/ports.conf /etc/apache2/ports.conf
ADD config/apache/envvars /etc/apache2/envvars

# Init
ADD init.sh /init.sh
RUN chmod 755 /*.sh \
# Add phpinfo script for INFO purposes
service apache2 restart; \
chown -R www-data:www-data /var/www ; 

# Awstats
ADD config/awstats/awstats.test.com.conf /etc/awstats

RUN /usr/lib/cgi-bin/awstats.pl -config=test.com -update; \
cp -r /usr/lib/cgi-bin /var/www/html/; \
chown www-data:www-data /var/www/html/cgi-bin/; \
chown www-data:www-data -Rf /var/mylog/; \
chmod -R 755 /var/www/html/cgi-bin/; \
rm /etc/awstats/awstats.conf ; 

WORKDIR /var/www/html

VOLUME /var/www/html
VOLUME /var/mylog
VOLUME /etc/awstats

EXPOSE 80

CMD ["/init.sh"]
