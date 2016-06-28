#!/usr/bin/env python

import os
import socket
import time
import subprocess
import sys
from os.path import join, dirname
from cloudify import ctx


# deploy blueprint utils resource
ctx.download_resource(resource_path='sampleutils.py', target_path=join(dirname(__file__), 'sampleutils.py'))
sys.path.append(dirname(__file__))
import sampleutils


def _copy_nginx_config_file():
    ctx.logger.info('Going to deploy Nginx configuration file...')
    ctx.download_resource(resource_path=join('config', 'nginx', 'nginx.conf'),
                          target_path='/home/vagrant/djangosample/src/mysite/nginx.conf')


def _updae_file_content(filename, changes):
    with open(filename) as f:
        file_data = f.read()
    for old_string, new_string in changes.iteritems():
        file_data = file_data.replace(old_string, new_string)
    with open(filename, 'w') as f:
        f.write(file_data)


def _set_nginx_config_file(host_ip, listen_port):
    config_file = '/home/vagrant/djangosample/src/mysite/nginx.conf'
    changes = {
        '{{HOST_IP}}': host_ip,
        '{{LISTEN_PORT}}': listen_port
    }
    _updae_file_content(config_file, changes)

    # sampleutils.create_folder('/home/www/mysite')
    # ctx.logger.info('Deploying blueprint resource {0} to {1}'.format(source, destination))
    # sampleutils.copy(source, destination)


def main():
    try:
        host_ip = ctx.source.instance.host_ip
        listen_port = ctx.source.instance.runtime_properties['listen_port']
        ctx.logger.info('nginx configuration, using ip: {}, port: {}'.format(host_ip, listen_port))
        _copy_nginx_config_file()
        _set_nginx_config_file(host_ip, listen_port)
        ctx.logger.info('Successfully updated nginx configuration')
    except:
        ctx.logger.exception('failed')
        raise


if __name__ == '__main__':
    main()
