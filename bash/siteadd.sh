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
	esc_www_data=${www_data//\//\\/}

	salt=`date +%s | sha256sum | base64 | head -c 32; echo`
	echo "Enter password for new user:"
	read pass
	crypted_pass=`perl -e 'print crypt("'$pass'","'$salt'")'`

	. ./common/services-stop.sh

	# data	
	echo "Creating user $user..."
	mkdir -p $www_data/$user/$public_html $www_data/$user/.cache $www_data/$user/.config $www_data/$user/.local
	touch $www_data/$user/.viminfo
	echo "Welcome to $user!" > $www_data/$user/$public_html/$index
	useradd -s /bin/bash -U -G www-data -d $www_data/$user -p $crypted_pass $user
	chown -R $user:$user $www_data/$user/$public_html $www_data/$user/.cache $www_data/$user/.config $www_data/$user/.local $www_data/$user/.viminfo

	# nginx
	echo "Creating nginx virtual host..." 
	config_name="nginx.conf.d.conf"
	if [ "$need_php" == false ]; then
		config_name="nginx.no-php.conf.d.conf"
	fi
	cat ./templates/$config_name | sed "s/\[user\]/$user/g" | sed "s/\[www_data\]/$esc_www_data/g" > ./templates/temp.conf
	mv ./templates/temp.conf $etc_nginx/sites-available/$user.conf
	ln -s $etc_nginx/sites-available/$user.conf $etc_nginx/sites-enabled/$user.conf

	# php-fpm
	if [ "$need_php" == true ]; then
		echo "Creating PHP-FPM pool (unix:/var/run/php-fpm.$user.sock)..."
		cat ./templates/php-fpm.pool.d.conf | sed "s/{{user}}/$user/g" > ./templates/temp.conf
		mv ./templates/temp.conf $etc_php_fpm/pool.d/$user.conf
	fi

	# pgsql
	if [ "$need_pgsql" == true ]; then
		echo "Creating PostreSQL database $dbuser..."
		sudo -u postgres psql -c "CREATE USER $dbuser ENCRYPTED PASSWORD '$pass'" -q
		sudo -u postgres psql -c "CREATE DATABASE $dbuser OWNER $dbuser" -q
	fi

	. ./common/services-start.sh
else
	echo "Usage: $0 [--no-php] [--no-pgsql] <sitename>"
fi
