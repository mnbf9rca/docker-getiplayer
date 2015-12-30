#!/bin/sh

# get_iplayer docker startup script
# author: mnbf9rca

# check write permissions...
chown --recursive www-data:www-data /var/www/get_iplayer/
chmod -R go+rw /var/www/get_iplayer/.get_iplayer

# first, start apache
service apache2 start

# then refresh the cache
/var/www/get_iplayer/get_iplayer --profile-dir /var/www/get_iplayer/.get_iplayer --refresh --refresh-future --type=all --nopurge --quiet

echo "startup complete"
