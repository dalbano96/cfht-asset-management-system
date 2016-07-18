#!/bin/sh
sudo yum -y install unzip
cd /home/snipeit-user/snipe-it/app/storage/dumps

# User selects file
prompt="Please select a file:"
options=( $(find -maxdepth 1 -print0 | xargs -0) )

PS3="$prompt "
select opt in "${options[@]}" "Quit" ; do 
    if (( REPLY == 1 + ${#options[@]} )) ; then
        exit

    elif (( REPLY > 0 && REPLY <= ${#options[@]} )) ; then
        echo  "You picked $opt which is file $REPLY"
        break

    else
        echo "Invalid option. Try another one."
    fi
done    
ls -ld $opt

# Unzip file and store output as txt file
unzip $opt > /root/cfht_asset_management/test_scripts/output.txt
echo break

# Retrieve unzipped filename
mysqlfile=`awk -F '/' 'NR==2 {print $2}' /root/cfht_asset_management/test_scripts/output.txt`

# Import into MySQL and Snipe-IT
mysql -u root -p whatislife < /home/snipeit-user/snipe-it/app/storage/dumps/database/${mysqlfile}

