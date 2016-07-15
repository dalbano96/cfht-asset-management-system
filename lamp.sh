#!/bin/sh

# install lamp stack and other php libraries
echo "Installing apache (httpd)..."
echo ""
sudo yum -y install httpd
sudo systemctl enable httpd.service
sudo systemctl start httpd.service

echo "Installing MySQL..."
echo ""
sudo yum -y install mariadb mariadb-server
sudo systemctl enable mariadb.service
sudo systemctl start mariadb.service

echo "Installing PHP libraries..."
echo ""
sudo yum -y install php php-mysql php-mcrypt php-pdo php-mbstring php-curl

echo "Installing mod_ssl"
echo ""
sudo yum -y install mod_ssl

# import config files from snipeit and httpd
echo "Importing Snipe-IT files"
u="$USER"
cp -rf config/snipe-it /$u
echo ""

echo "Importing Apache configuration files"
cp -rf config/httpd /etc
systemctl restart httpd.service

# creating a user with sudo privileges
sudo adduser --group sudo snipeit-user

# import database (y/n) 
echo ""
echo Would you like to import another database [y/n]?	
read input
while [ $input != "y" ] && [ $input != "Y" ] && [ $input != "n" ] && [ $input != "N" ]
do
	echo Please try again [y/n]
	read input
done
if [[ $input = "y" ||  $input = "Y" ]]
then
	echo "work in progress"
elif [[ $input = "n" ||  $input = "N" ]];
then
	echo "Change MySQL root password [y/n]?"
	read input
	if [[ $input = "n" || $input = "N" ]]; then
		ticket=1
		echo "Please enter the NAME of the new database!"
		read dbname
		echo "Enter root password:"
		read rootpasswd
		echo "Creating new database..."
		mysql -u root -p${rootpasswd} -e "CREATE DATABASE ${dbname};"
		if [ "$?" -eq 0 ];
		then ticket=0
		else ticket=1
		fi
		while [ $ticket != 0 ]
		do
			echo ""
			echo "Login failed, please try again"
			echo ""
			echo "Enter root password:"
			read rootpasswd
			mysql -u root -p${rootpasswd} -e "CREATE DATABASE ${dbname};"
			if [ "$?" -eq 0 ];
			then ticket=0
			else ticket=1
			fi
		done
		echo ""
		echo "Database successfully created!"
		echo "Showing existing databases..."
		mysql -u root -p${rootpasswd} -e "show databases;"
		if [ "$?" -eq 0 ];
		then ticket=0
		else ticket=1
		fi
		echo ""

	else
		ticket=1
		echo "Enter current password:"
		read oldpasswd
		echo "Enter new password:"
		read rootpasswd
		echo "Changing root password..."
		mysqladmin -u root -p${oldpasswd} password ${rootpasswd}
		if [ "$?" -eq 0  ];
		then ticket=0
		else ticket=1
		fi
		while [ $ticket != 0 ]
		do
			echo ""
			echo "Login Failed, please try again"
			echo "Enter current password:"
			read oldpasswd
			echo "Enter new password:"
			read rootpasswd
			mysqladmin -u root -p${oldpasswd} password ${rootpasswd}
			if [ "$?" -eq 0 ];
			then ticket=0
			else ticket=1
			fi
		done
		echo ""
		echo Success! MySQL root password has been set to $rootpasswd
		echo "Please enter the NAME of the new database!"
		read dbname
		echo "Creating new database..."
		mysql -u root -p${rootpasswd} -e "CREATE DATABASE ${dbname};"
		echo ""
		echo "Database successfully created!"
		echo ""
		echo "Showing existing databases..."
		mysql -u root -p${rootpasswd} -e "show databases;"
		echo ""
	fi
fi
