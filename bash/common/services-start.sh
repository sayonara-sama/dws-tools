echo "Starting services..."
service php5-fpm start > /dev/null
service nginx start > /dev/null
service vsftpd start > /dev/null

