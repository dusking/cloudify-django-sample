#!/usr/bin/env python

import os
from cloudify import ctx


def _set_nginx_config_file(host_ip):
    project_root_dir = os.path.expanduser('~/djangosample/src')
    config_file = os.path.join(project_root_dir, 'mysite/nginx.conf')
    params = ctx.source.node.properties.copy()
    params.update({'host_ip': host_ip,
                   'project_root_dir': project_root_dir})
    ctx.download_resource_and_render(resource_path='config/nginx/nginx.conf.template',
                                     target_path=config_file,
                                     template_variables=params)


def main():
    host_ip = ctx.source.instance.host_ip
    listen_port = ctx.source.node.properties['port']
    ctx.logger.info('nginx configuration, using ip: {0}, port: {1}'.format(host_ip, listen_port))
    _set_nginx_config_file(host_ip)
    ctx.logger.info('Successfully updated nginx configuration')


if __name__ == '__main__':
    main()
