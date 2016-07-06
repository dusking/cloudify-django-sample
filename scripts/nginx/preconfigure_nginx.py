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


def _set_nginx_config_file(host_ip):
    config_file = os.path.join(os.path.expanduser('~'), 'djangosample/src/mysite/nginx.conf')
    project_root_dir = os.path.join(os.path.expanduser('~'), 'djangosample/src')
    params = ctx.source.node.properties.copy()
    params.update({'host_ip': host_ip,
                   'project_root_dir': project_root_dir})
    sampleutils.download_resource_and_render(source='config/nginx/nginx.conf.template',
                                             destination=config_file,
                                             params=params)


def main():
    try:
        host_ip = ctx.source.instance.host_ip
        listen_port = ctx.source.node.properties['port']
        ctx.logger.info('nginx configuration, using ip: {}, port: {}'.format(host_ip, listen_port))
        _set_nginx_config_file(host_ip)
        ctx.logger.info('Successfully updated nginx configuration')
    except:
        ctx.logger.exception('failed')
        raise


if __name__ == '__main__':
    main()
