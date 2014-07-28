#!/bin/bash

. ./common/init.sh

if [ $EUID -ne 0 ]; then
	echo "You must be a root"
	exit 1
fi

if [ $1 ]; then
	user=$1
	dbuser=${user//\./_}
	dbuser=${dbuser//-/_}
	. ./common/services-stop.sh

	echo "Removing virtual host $user with all related data..."
	userdel $user;
	rm -rf $www_data/$user
	rm $etc_nginx/sites-enabled/$user.conf $etc_nginx/sites-available/$user.conf $etc_php_fpm/pool.d/$user.conf
	sudo -u postgres psql -c "DROP DATABASE $dbuser" -q
	sudo -u postgres psql -c "DROP USER $dbuser" -q

	. ./common/services-start.sh
else
	echo "Usage: $0 <sitename>"
fi
