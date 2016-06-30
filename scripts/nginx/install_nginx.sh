#!/bin/bash

set -e

function install() {
    set +e
    aptget_cmd=$(which apt-get 2> /dev/null)
    yum_cmd=$(which yum 2> /dev/null)
    set -e

    if [[ ! -z ${yum_cmd} ]]; then
        ctx logger info "Update environment for nginx"
        sudo yum -y install epel-release
        ctx logger info "Going to install nginx"
        sudo yum -y install nginx
    elif [[ ! -z ${aptget_cmd} ]]; then
        ctx logger info "Update environment for nginx"
        sudo apt-get update
        sudo apt-get -y install python-software-properties
        sudo apt-get -y install software-properties-common
        sudo add-apt-repository ppa:nginx/stable -y
        sudo apt-get update
        ctx logger info "Going to install nginx"
        sudo apt-get -y install nginx
    else
        ctx logger error "Failed to install nginx: Neither 'yum' nor 'apt-get' were found on the system"
        exit 1;
    fi
}

LISTEN_PORT=$(ctx node properties port)
ctx instance runtime_properties listen_port ${LISTEN_PORT}

install