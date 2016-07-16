#!/bin/sh
sudo yum -y install unzip
cd /home/snipeit-user/snipe-it/app/storage/dumps

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
unzip $opt > /root/cfht_asset_management/test_scripts/selectedout.txt

mysql -u root -p whatislife < /home/snipeit-user/snipe-it/app/storage/dumps/database/${unopt}
