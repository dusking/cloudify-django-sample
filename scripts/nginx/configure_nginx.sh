#!/bin/bash

set -e

ctx logger info "Configuring nginx"
if [ -f /etc/nginx/sites-enabled/nginx.conf ]; then
    sudo rm /etc/nginx/sites-enabled/nginx.conf
fi
sudo ln -s ~/djangosample/src/mysite/nginx.conf /etc/nginx/sites-enabled/

ctx logger info "Starting nginx service"
sudo service nginx restart