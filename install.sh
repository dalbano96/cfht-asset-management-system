#!/bin/sh

# install lamp stack and other php libraries
echo "Installing apache (httpd)..."
echo ""
sudo yum -y install httpd
sudo systemctl enable httpd.service
sudo systemctl start httpd.service
echo ""
echo "Installing MySQL..."
echo ""
sudo yum -y install mariadb mariadb-server
sudo systemctl enable mariadb.service
sudo systemctl start mariadb.service
echo ""
echo "Installing PHP libraries..."
echo ""
sudo yum -y install php php-mysql php-mcrypt php-pdo php-mbstring php-curl
echo ""
echo "Installing mod_ssl"
echo ""
sudo yum -y install mod_ssl
echo ""
sudo yum -y install unzip
sudo systemctl start unzip
echo ""

# create user with sudo priv set password as well
echo "Creating non-root user with sudo privileges"
defuser=snipeit-user
sudo adduser ${defuser}
defpasswd=!akamai!
echo "Setting user password..."
echo -e "${defpasswd}\n${defpasswd}" | passwd snipeit-user

# import config files from snipeit and httpd
echo "Importing Snipe-IT files"
cp -rf config/snipe-it /home/${defuser}
echo ""
echo "Importing Apache configuration files"
cp -rf config/httpd /etc
systemctl restart httpd.service
echo "Importing sudoers file"
cp -f config/sudoers /etc
echo "Importing iptables config"
cp -f config/iptables /etc/sysconfig

# restarting httpd, iptables, and mariadb
sudo systemctl restart httpd.service
sudo systemctl restart iptables.service
sudo systemctl restart mariadb.service

# import database (y/n) 
echo ""
echo Would you like to import another database [y/n]?	
read input
while [ $input != "y" ] && [ $input != "Y" ] && [ $input != "n" ] && [ $input != "N" ]
do
	echo Please try again [y/n]
	read input
done

dbname=snipeit
toggle=1

if [[ $input = "y" ||  $input = "Y" ]]
then
	# Configure MySQL
	echo "Press enter if MySQL root password has not been configured"
        mysqladmin -u root -p password ${defpasswd}
        ticket=1
        if [ "$?" -eq 0 ];
        then ticket=0
        else ticket=1
        fi
        while [ $ticket != 0 ]
        do
                echo ""
                echo "Password change failed, please try again"
                echo ""
                mysqladmin -u root -p password ${defpasswd}
        done
        echo ""
        echo "Password successfully changed to default password!"
        echo ""
        echo "Creating database..."
        mysql -u root -p${defpasswd} -e "CREATE DATABASE ${dbname};"
        ticket=1
        if [ "$?" -eq 0 ];
        then ticket=0
        else ticket=1
        fi
        while [ $ticket != 0 ]
        do
                echo ""
                echo "Login failed, please try again"
                echo ""
                mysql -u root -p -e "CREATE DATABASE ${dbname};"
                if [ "$?" -eq 0 ];
                then ticket=0
                else ticket=1
                fi
        done
        echo ""
        echo "Database successfully created!"

	# Import database and set app key
	sudo yum -y install unzip
	cd /home/${defuser}/snipe-it/app/storage/dumps
	
	# User selects file
	prompt="Please select a file:"
	options=( $(find -maxdepth 1 -print0 | xargs -0) )
	PS3="$prompt "
	select opt in "${options[@]}" "Quit" ; do
		if (( REPLY == 1 + ${#options[@]} ));
		then exit
		elif (( REPLY > 0 && REPLY <= ${options[@]} ));
		then
			echo "You picked $opt which is file $REPLY"
			break
		else
			echo "Invalid option. Try another one."
		fi
	done
	ls -ld $opt	

	# Unzip file and store output as text file
	unzip $opt > /home/${defuser}/snipe-it/output.txt
	
	# Retrieve unzipped filname
	mysqlfile=`awk -F '/' 'NR==2 {print $2}' /home/${defuser}/snipe-it/output.txt`
	
	# Import into MySQL and Snipe-IT
	mysql -u root -p${defpasswd} ${dbname} < /home/${defuser}/snipe-it/app/storage/dumps/database/${mysqlfile}

	origappkey=QiARACtvQRMK3D7oc3XdKb6Zp5WR5sUv
	sed -i "s/Change_this_key_or_snipe_will_get_ya/${origappkey}/g" /home/${defuser}/snipe-it/app/config/production/app.php
	toggle=1
	
elif [[ $input = "n" ||  $input = "N" ]];
then
	echo "Press enter if MySQL root password has not been configured"
	mysqladmin -u root -p password ${defpasswd}
	ticket=1
	if [ "$?" -eq 0 ];
	then ticket=0
	else ticket=1
	fi
	while [ $ticket != 0 ]
	do
		echo ""
		echo "Password change failed, please try again"
		echo ""
		mysqladmin -u root -p password ${defpasswd}
	done
	echo ""
	echo "Password successfully changed to default password!"
	echo ""
	echo "Creating database..."
	mysql -u root -p${defpasswd} -e "CREATE DATABASE ${dbname};"
	ticket=1
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
		mysql -u root -p -e "CREATE DATABASE ${dbname};"
		if [ "$?" -eq 0 ];
		then ticket=0
		else ticket=1
		fi
	done
	echo ""
	echo "Database successfully created!"
	echo ""

	toggle=0
fi

# Configure snipe-it database.php file
echo Doing stuff
sed -i "s/mysqldb/${dbname}/g" /home/${defuser}/snipe-it/app/config/production/database.php
sed -i "s/mysqlpwd/${rootpasswd}/g" /home/${defuser}/snipe-it/app/config/production/database.php
echo Stuff done

# Configure snipe-it app.php file - hostname used literally
hstname=$(hostname)
sed -i "s/replaceserver/${hstname}/g" /home/${defuser}/snipe-it/app/config/production/app.php

# Configure httpd virtualhost
sed -i "s/replaceroot/${defuser}/g" /etc/httpd/conf.d/snipeit-httpd.conf
sed -i "s/replaceserver/${hstname}/g" /etc/httpd/conf.d/snipeit-httpd.conf
echo "Done as well!"

# Configure app permissions
chown -R ${defuser}:${defuser} /home/${defuser}/snipe-it/app/storage /home/${defuser}/snipe-it/app/private_uploads /home/${defuser}/snipe-it/public/uploads
chmod -R 777 /home/${defuser}/snipe-it/app/storage
chmod -R 777 /home/${defuser}/snipe-it/app/private_uploads
chmod -R 777 /home/${defuser}/snipe-it/public/uploads

# Restart LAMP
sudo systemctl restart httpd.service
sudo systemctl restart mariadb.service
sudo systemctl restart iptables.service

# If user did not import database, snipe-it will create a new one
if [ toggle -eq 0 ];
then
	# Install Dependencies - requires sudo
	echo Installing dependencies
	cd /home/${defuser}/snipe-it
	#su ${defuser} << 'EOF'
	curl -sS https://getcomposer.org/installer | php
	php composer.phar install --no-dev --prefer-source

	# Generate app key
	echo Generating app key
	cd /home/${defuser}/snipe-it
	php artisan key:generate > appkey.txt
	perl -lne 'print $1 while (/\[(.*?)\]/g)' appkey.txt > output.txt
	appkey=`cat output.txt`
	echo $appkey
	sed -i "s/Change_this_key_or_snipe_will_get_ya/${appkey}/g" /home/${defuser}/snipe-it/app/config/production/app.php
	
	# Initial install (work in progress alongside db import) - missing autoload.php file
	echo Installing application
	cd /home/${defuser}/snipe-it
	php artisan app:install --env=production

else break
fi


echo ""
echo "Snipe-IT web app has been configured. You are ready to go"
echo ""
