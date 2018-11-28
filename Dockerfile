FROM phusion/baseimage:0.9.22
MAINTAINER Jochen Breuer "brejoc@gmail.com"

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get -y update
RUN add-apt-repository -y ppa:ondrej/php
RUN apt-get update  

RUN apt-get install  -y apache2 php libapache2-mod-php php-mcrypt php-mysql
RUN apt-get install  -y php7.0-gd php7.0-json php7.0-mysql php7.0-curl php7.0-mbstring
RUN apt-get install  -y php7.0-intl php7.0-mcrypt php-imagick php7.0-xml php7.0-zip
RUN apt-get install -y php-mysql php-zip php-gd php-json php-curl php-mbstring php-intl php-mcrypt php-imagick php-xml
RUN apt-get install -y sqlite3 libsqlite3-dev php-sqlite3 php7.0-sqlite3
RUN apt-get install -y bzip2 
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
RUN apt-get autoremove


RUN echo "ServerName localhost">>/etc/apache2/apache2.conf

RUN rm -rf /etc/service/sshd /etc/my_init.d/00_regen_ssh_host_keys.sh

RUN curl -k https://download.nextcloud.com/server/releases/nextcloud-14.0.4.tar.bz2 | tar jx -C /var/www/
RUN mkdir /var/www/nextcloud/data
RUN chown -R www-data:www-data /var/www/nextcloud
RUN chmod 770 -R /var/www/nextcloud/data

ADD ./nextcloud.conf /etc/apache2/sites-available/
RUN rm -f /etc/apache2/sites-enabled/000*
RUN ln -s /etc/apache2/sites-available/nextcloud.conf /etc/apache2/sites-enabled/nextcloud.conf
RUN a2enmod rewrite
RUN a2enmod headers
RUN a2enmod env
RUN a2enmod dir
RUN a2enmod mime
RUN service apache2 restart
ADD rc.local /etc/rc.local
RUN chown root:root /etc/rc.local

VOLUME ["/var/www/nextcloud/data", "/var/www/nextcloud/config"]
EXPOSE 80
CMD ["/sbin/my_init"]
