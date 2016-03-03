#! /bin/sh

N_NODES="$1"

# install nginx
apt-get install nginx-full -y

# configure upstream based on n_nodes
echo 'upstream lb_upstream {' > /etc/nginx/conf.d/lb-upstream.conf
for node in `seq $N_NODES`; do
	echo "server 10.99.80.$((node+10));" >> /etc/nginx/conf.d/lb-upstream.conf
done
echo '}' >> /etc/nginx/conf.d/lb-upstream.conf

# create certificate
mkdir -p /etc/nginx/ssl
openssl req -x509 -subj '/C=SE/L=Stockholm/O=VLB/CN=localhost' -new -nodes -newkey rsa:2048 -keyout /etc/nginx/ssl/lb.key -out /etc/nginx/ssl/lb.crt > /dev/null

# clear out enabled sites
rm /etc/nginx/sites-enabled/*

# install config
cp /vagrant/files/nginx-lb.conf /etc/nginx/sites-enabled/lb.conf

# restart nginx
systemctl restart nginx
