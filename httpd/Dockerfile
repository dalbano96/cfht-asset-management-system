FROM centos:latest
RUN yum update -y && yum install -y httpd
CMD /usr/sbin/httpd
ENTRYPOINT ["/usr/sbin/httpd", "-D", "FOREGROUND"]
