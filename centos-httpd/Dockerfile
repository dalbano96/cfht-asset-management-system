FROM centos:latest
RUN yum update -y && yum install -y httpd \
	 -y php php-mysql
ADD ./src/vhost.conf /etc/httpd/conf.d/default-vhost.conf
ADD ./src/info.php /var/www/html/info.php
EXPOSE 80
CMD /usr/sbin/httpd
ENTRYPOINT ["/usr/sbin/httpd", "-D", "FOREGROUND"]
