echo "Stopping services..."
service vsftpd stop > /dev/null
service nginx stop > /dev/null
service php5-fpm stop > /dev/null
