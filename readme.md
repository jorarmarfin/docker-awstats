# Docker Awstats

* apt-get install awstats
* a2enmod cgi
* /etc/init.d/apache2 restart
* mv /etc/awstats/awstats.conf /etc/awstats/awstats.test.com.conf

~~~~
# Change to Apache log file, by default it's /var/log/apache2/access.log
LogFile="/var/log/apache2/access.log"
 
# Change to the website domain name
SiteDomain="test.com"
HostAliases="www.test.com localhost 127.0.0.1"
 
# When this parameter is set to 1, AWStats adds a button on report page to allow to "update" statistics from a web browser
AllowToUpdateStatsFromBrowser=1
~~~~

* /usr/lib/cgi-bin/awstats.pl -config=test.com -update
* cp -r /usr/lib/cgi-bin /var/www/html/
* chown www-data:www-data /var/www/html/cgi-bin/
* chmod -R 755 /var/www/html/cgi-bin/
* /cgi-bin/awstats.pl?config=test.com
# config apache
* Alias /awstatsclasses "/usr/share/awstats/lib/"
* Alias /awstats-icon/ "/usr/share/awstats/icon/"
* Alias /awstatscss "/usr/share/doc/awstats/examples/css"
* ScriptAlias /statistics/ /usr/lib/cgi-bin/
* Redirect /awstats /statistics/awstats.pl
* Options +ExecCGI -MultiViews +SymLinksIfOwnerMatch
# Docker-compose
~~~~
version: '3.5'
services:
  web:
    container_name: srv-awstats
    image: jorarmarfin/awstats:0.1
    volumes:
      - ./awstats/config:/etc/awstats/
      - ./awstats/logs:/var/mylog/
    ports:
      - 9005:80
~~~~