#!/bin/bash

set -e

function uninstall() {
    set +e
    aptget_cmd=$(which apt-get 2> /dev/null)
    yum_cmd=$(which yum 2> /dev/null)
    set -e

    if [[ ! -z ${yum_cmd} ]]; then
        sudo yum -y remove epel-release
        sudo yum -y remove nginx
    elif [[ ! -z ${aptget_cmd} ]]; then
        sudo apt-get -y autoremove --purge nginx
    else
        ctx logger error "Failed to uninstall nginx: Neither 'yum' nor 'apt-get' were found on the system"
        exit 1;
    fi
}

sudo service nginx stop

uninstall