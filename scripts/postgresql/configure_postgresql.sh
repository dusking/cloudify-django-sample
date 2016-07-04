#!/bin/bash

set -e


function init_db_if_on_centos() {
    set +e
    yum_cmd=$(which yum 2> /dev/null)
    if [[ ! -z ${yum_cmd} ]]; then
        ctx logger info "Creating a new PostgreSQL database cluster, and starting"
        sudo postgresql-setup initdb
        ctx logger info "Updating pg_hba.conf"
        sudo bash -c "cat /var/lib/pgsql/data/pg_hba.conf | awk '/^host/{gsub(/ident/, \"md5\")};{print}' > /var/lib/pgsql/data/pg_hba.conf"
        ctx logger info "Starting postgresql"
        sudo chkconfig postgresql on
        sudo systemctl start postgresql
        sudo systemctl enable postgresql
    fi
    set -e
}

init_db_if_on_centos

ctx logger info "Downloading postgres configuration script"
ctx download_resource scripts/postgresql/postgresql_configuration.sh /tmp/postgresql_configuration.sh
chmod +x /tmp/postgresql_configuration.sh

ctx logger info "Configuring postgresql using workaround for: su must be run from a terminal"
sudo su - postgres -c "/tmp/postgresql_configuration.sh"
