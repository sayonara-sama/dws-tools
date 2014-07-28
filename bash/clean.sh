#!/bin/bash

. ./common/init.sh

if [ $EUID -ne 0 ]; then
	echo "You must be a root"
	exit 1
fi

if [ $1 ]; then
	user=$1

	if [ -d "$www_backup/$user" ]; then
		time=`date +'%s'`;
		for file in `ls $www_backup/$user`; do
			stat=`stat -c%Y $www_backup/$user/$file`
			delta=$(($time - $stat))
			if [ $delta -gt $storage_time ]; then
				rm -rf $www_backup/$user/$file
			fi
		done
	fi	
else
	echo "Usage: $0 <sitename>"
fi
