#!/bin/bash

if [ -n "$USERNAME" ] && [ -n "$PASSWORD" ]; then
	htpasswd -bc /etc/nginx/htpasswd $USERNAME $PASSWORD
	echo Done.
else
	echo Using no auth.
	sed -i 's%auth_basic "Restricted";% %g' /etc/nginx/conf.d/default.conf
	sed -i 's%auth_basic_user_file /etc/nginx/htpasswd;% %g' /etc/nginx/conf.d/default.conf
fi

#openssl req -x509 -nodes -days 3650 -newkey rsa:2048 -keyout /privkey.pem -out /cert.pem -batch
