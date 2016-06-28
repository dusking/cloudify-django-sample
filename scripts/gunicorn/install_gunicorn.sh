#!/bin/bash

set -e

ctx logger info "Installing gunicorn"
cd ${VIRTUALENV}
sudo bin/pip install gunicorn

# run it using:
#bin/python -m gunicorn.app.wsgiapp --bind 0.0.0.0:8000 mysite.wsgi:application --chdir /home/vagrant/djangosample/src/
#bin/python -m gunicorn.app.wsgiapp --bind unix:/home/vagrant/djangosample/src/mysite/mysite.sock mysite.wsgi:application --chdir /home/vagrant/djangosample/src/