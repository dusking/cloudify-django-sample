#!/bin/bash

set -e

function uninstall() {
    set +e
    aptget_cmd=$(which apt-get 2> /dev/null)
    yum_cmd=$(which yum 2> /dev/null)
    set -e

    if [[ ! -z ${yum_cmd} ]]; then
        ctx logger info "Going to install postgresql"
        sudo yum -y remove postgresql-server
        sudo yum -y remove postgresql
        sudo yum -y remove postgresql-contrib
        sudo yum -y remove postgresql-libs
        ctx logger info "Going to install postgresql dependencies"
        pip uninstall -y psycopg2
    elif [[ ! -z ${aptget_cmd} ]]; then
        ctx logger info "Going to uninstall postgresql"
        sudo apt-get -y autoremove --purge postgresql-contrib
        sudo apt-get -y autoremove --purge postgresql
        ctx logger info "Going to uninstall postgresql dependencies"
        sudo apt-get -y autoremove --purge python-psycopg2
        pip uninstall -y psycopg2
    else
        ctx logger error "Failed to uninstall postgresql: Neither 'yum' nor 'apt-get' were found on the system"
        exit 1;
    fi
}

uninstall