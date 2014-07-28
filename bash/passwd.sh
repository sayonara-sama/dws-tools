#!/bin/bash

if [ $EUID -ne 0 ]; then
	echo "You must be a root"
	exit 1
fi

if [ $1 ]; then
	user=$1
	dbuser=${user//\./_}
	
	salt=`date +%s | sha256sum | base64 | head -c 32; echo`
	echo "Enter new password for user $user:"
	read pass
	crypted_pass=`perl -e 'print crypt("'$pass'","'$salt'")'`
		
	usermod -p $crypted_pass $user
	sudo -u postgres psql -c "ALTER USER $dbuser ENCRYPTED PASSWORD '$pass'" -q
else
	echo "Usage: $0 <sitename>"
fi
