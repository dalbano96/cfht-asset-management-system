#!/bin/sh

# install lamp stack and other php libraries
#sudo yum clean all;
#sudo yum update;
#sudo yum -y install httpd mysql php php-mysql php-pdo php-mbstring php-curl;

# import mysql database
# ...
# ...
# ...

# import httpd configuration files from backup location
# ...
# ...
# ...

# import snipe-it config files from backup location
echo Would you like to import another database [y/n]?	
read input
while [[$input = "y" || $input = "Y" || $input = "n" || $input = "N"]]
	read -p "Please try again [y/n]": input
done
if [[ $input = "y" ||  $input = "Y" ]]
then
	echo You entered yes
elif [[ $input = "n" ||  $input = "N" ]]
then
	echo You entered no
fi

# set permissions for files