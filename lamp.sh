#!/bin/sh

# install lamp stack and other php libraries
#sudo yum clean all;
#sudo yum update;
#sudo yum -y install httpd mysql php php-mysql php-pdo php-mbstring php-curl;

# import config files from snipeit and httpd
# ...
# ...
# ...

# import mysql database
# ...
# ...
# ...

# import httpd configuration files from backup location
# ...
# ...
# ...

# import database (y/n) 
echo Would you like to import another database [y/n]?	
read input
while [ $input != "y" ] && [ $input != "Y" ] && [ $input != "n" ] && [ $input != "N" ]
do
	echo Please try again [y/n]
	read input
done
if [[ $input = "y" ||  $input = "Y" ]]
then
	# After importing Snipe-IT files, locate MySQL backups
elif [[ $input = "n" ||  $input = "N" ]];
then
	echo "Change MySQL root password (y/n)?"
	read input
	if [[ $input = "n" || $input = "N" ]]; then
		ticket=1
		echo "Please enter the NAME of the new database!"
		read dbname
		echo "Please enter password for root"
		read rootpasswd
		echo "Creating new database..."
		mysql -u root -p${rootpasswd} -e "CREATE DATABASE ${dbname};"
		while [ $ticket != 0 ]
		do
			echo "Login failed, please try again :("
			read rootpasswd
			mysql -u root -p${rootpasswd} -e "CREATE DATABASE ${dbname};"
			if [ "$?" -eq 0 ];
			then ticket=0
			else ticket=1
			fi
		done
		echo "Database successfully created!"
		echo "Showing existing databases..."
		mysql -u root -p${rootpasswd} -e "show databases;"
		if [ "$?" -eq 0 ];
		then ticket=0
		else ticket=1
		fi
		echo ""
		echo "You're good now :)"

	else
		echo "Enter current password"
		read oldpasswd
		echo "Enter new password"
		read rootpasswd
		echo "Changing root password..."
		mysqladmin -u root -p${oldpasswd} password ${rootpasswd}
		echo MySQL root password has been set to $rootpasswd
		echo "Please enter the NAME of the new database!"
		read dbname
		echo "Creating new database..."
		mysql -u root -p -e "CREATE DATABASE ${dbname};"
		echo "Database successfully created!"
		echo "Showing existing databases..."
		mysql -u root -p -e "show databases;"
		echo ""
		echo "You're good now :)"
	fi
fi

# set permissions for files
