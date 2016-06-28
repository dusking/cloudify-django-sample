#!/bin/bash

set -e

ctx logger info "Going to uninstall gunicorn"
cd ${VIRTUALENV}
sudo bin/pip uninstall -y gunicorn