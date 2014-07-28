. ./common/config.sh
if [ -f ~/.dwstrc ]; then
	. ~/.dwstrc
fi

args=`getopt -o "" -l "no-pgsql,no-php" -n "$0" -- "$@"`
if [ $? -ne 0 ]; then
	exit 1
fi
eval set -- $args

while true; do
	case "$1" in
		--no-pgsql)
			need_pgsql=false
			shift;;
		--no-php)
			need_php=false
			shift;;
		--)
			shift
			break;;
	esac
done

