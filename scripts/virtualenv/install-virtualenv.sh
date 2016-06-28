#!/bin/bash

set -e

ctx logger info "install virtual env..."

function install() {
    set +e
    aptget_cmd=$(which apt-get)
    yum_cmd=$(which yum)
    set -e

    if [[ ! -z ${yum_cmd} ]]; then
        sudo yum -y install python-setuptools
    elif [[ ! -z ${aptget_cmd} ]]; then
        sudo apt-get install python-pip
    else
        ctx logger error "Failed to install nginx: Neither 'yum' nor 'apt-get' were found on the system"
        exit 1;
    fi
}

install

pip install virtualenvwrapper

#pip install virtualenvwrapper