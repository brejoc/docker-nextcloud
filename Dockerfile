FROM phusion/baseimage:0.9.15
MAINTAINER Jochen Breuer "brejoc@gmail.com"
RUN apt-get -y update
RUN apt-get install -y apache2 mariadb-server libapache2-mod-php7.0
RUN apt-get install -y php7.0-gd php7.0-json php7.0-mysql php7.0-curl php7.0-mbstring
RUN apt-get install -y php7.0-intl php7.0-mcrypt php-imagick php7.0-xml php7.0-zip
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN rm -rf /etc/service/sshd /etc/my_init.d/00_regen_ssh_host_keys.sh

RUN curl -k https://download.nextcloud.com/server/releases/nextcloud-12.0.3.tar.bz2 | tar jx -C /var/www/
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

ADD rc.local /etc/rc.local
RUN chown root:root /etc/rc.local

VOLUME ["/var/www/nextcloud/data", "/var/www/nextcloud/config"]
EXPOSE 80
CMD ["/sbin/my_init"]
