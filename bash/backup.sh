#!/bin/bash

. ./common/init.sh

if [ $EUID -ne 0 ]; then
	echo "You must be a root"
	exit 1
fi

if [ $1 ]; then
	user=$1

	if [ ! -d $www_data/$user/$public_html ]; then
		echo "$www_data/$user/$public_html not found"
		exit 1
	fi

	dbuser=${user//\./_}
	date=`date +'%F_%T'`

	mkdir -p $www_backup/$user

	tmp=`pwd`
	cd $www_data/$user/$public_html
	tar -zcf $www_backup/$user/$date.tar.gz ./
	cd $tmp
		
	sudo -u postgres pg_dump $dbuser > $www_backup/$user/$date.sql
else
	echo "Usage: $0 <sitename>"
fi
