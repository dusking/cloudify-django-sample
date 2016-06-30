#!/bin/bash

set -e

ctx logger info "Downloading postgres configuration script"
ctx download_resource scripts/postgresql/postgresql_configuration.sh /tmp/postgresql_configuration.sh
chmod +x /tmp/postgresql_configuration.sh

ctx logger info "Configuring postgresql using workaround for: su must be run from a terminal"
sudo su - postgres -c "/tmp/postgresql_configuration.sh"
