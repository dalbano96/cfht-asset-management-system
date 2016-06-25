FROM centos:latest 
RUN yum update -y; yum install -y httpd; yum install -y mariadb-server mariadb; yum install -y php php-mysql; yum install -y php-mcrypt; yum install -y php-fileinfo; yum install -y php-pdo; yum install -y php-mbstring; yum install -y php-curl; systemctl enable httpd.service; systemctl enable mariadb.service; systemctl disable iptables.service; systemctl disable firewalld.service

ADD ./src/vhost.conf /etc/httpd/conf.d/default-vhost.conf	
ADD ./src/info.php /var/www/html/info.php
COPY ./src/snipe-it /var/www/
EXPOSE 80 
CMD /usr/sbin/httpd
ENTRYPOINT ["/usr/sbin/httpd", "-D", "FOREGROUND"]
CMD ["/usr/sbin/init"]
