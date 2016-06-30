#!/bin/bash

set -e

function install() {
    set +e
    aptget_cmd=$(which apt-get 2> /dev/null)
    yum_cmd=$(which yum 2> /dev/null)
    set -e

    if [[ ! -z ${yum_cmd} ]]; then
        ctx logger info "Going to install prerequisites"
        sudo yum -y groupinstall 'Development Tools'  # or just: yum install gcc
        sudo yum -y install python-devel
        sudo yum -y install postgresql-devel
        sudo yum -y install python-pip
        sudo yum -y install python-wheel
        sudo yum -y upgrade python-setuptools
        ctx logger info "Going to install postgresql"
        sudo yum -y install postgresql-server
        sudo yum -y install postgresql
        sudo yum -y install postgresql-contrib
        sudo yum -y install postgresql-libs
        ctx logger info "Going to install postgresql dependencies"
        pip install psycopg2
    elif [[ ! -z ${aptget_cmd} ]]; then
        ctx logger info "Going to install prerequisites"
        sudo apt-get update
        sudo apt-get -y install python-pip
        sudo apt-get -y install python-dev
        sudo apt-get -y install libpq-dev
        ctx logger info "Going to install postgresql"
        sudo apt-get -y install postgresql
        sudo apt-get -y install postgresql-contrib
        ctx logger info "Going to install postgresql dependencies"
        sudo apt-get -y install python-psycopg2
        pip install psycopg2
    else
        ctx logger error "Failed to install nginx: Neither 'yum' nor 'apt-get' were found on the system"
        exit 1;
    fi
}

install