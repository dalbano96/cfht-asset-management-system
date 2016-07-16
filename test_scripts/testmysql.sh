#!/bin/sh

echo "Enter Username"
read uname
mysqluser=${uname//[^a-zA-Z0-9/_]}
echo "Enter new password"
read passwd
echo "Confirm new password"
read passwd2
if [[ $passwd = $passwd2 ]];
then
	echo "Coolios"
else
	echo "You have failed"
	exit
fi

if [ -f /etc/my.cnf ];
then
	mysql -e "CREATE DATABASE usercreated;"
	mysql -e "CREATE USER ${mysqluser} IDENTIFIED BY '${passwd}';"
	mysql -e "GRANT ALL PRIVILEGES ON usercreated TO '${mysqluser};"
	mysql -e "FLUSH PRIVILEGES;"
fi
