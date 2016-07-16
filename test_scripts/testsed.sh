#!/bin/sh
echo Doing stuff
sed -i "s/mysqldb/thisiscool/g" /root/snipe-it/app/config/production/database.php
sed -i "s/mysqlpwd/testing/g" /root/snipe-it/app/config/production/database.php
echo Stuff done
