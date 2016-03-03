#! /bin/sh

NODE="$1"

# install nginx
apt-get install nginx-light -y

# write node-name to index-file
echo $NODE > /var/www/html/index.html
