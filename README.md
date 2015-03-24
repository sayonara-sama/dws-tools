# Debian Web Server Tools #

Administration tools for web-server:

* Compatible with Debian-based operating systems
* Works with nginx+PostgreSQL+PHP-FPM

## Usage ##

Adding site:

`# ./siteadd.sh [--no-php] [--no-pgsql] <sitename>`

Removing site:

`# ./sitedel.sh <sitename>`

Changing user's password:

`# ./passwd.sh <sitename>`

Making a backup:

`# ./backup.sh <sitename>`

Removing old backups (7 days old by default):

`# ./clean.sh <sitename>`

## User's configuration ##

You can override default options in .dwstrc file that should be in user's home directory. It has simple format: option=value. Default options you can see in common/config.sh.
