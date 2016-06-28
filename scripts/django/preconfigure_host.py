#!/usr/bin/env python

from cloudify import ctx

# saving the hot id for future use (the host_xxxx folder name)
ctx.logger.info('Setting Host IP Runtime Property.')
host_id = ctx.target.instance.id
ctx.source.instance.runtime_properties['host_id'] = host_id
ctx.logger.info('Host IP Runtime Property been set: {}'.format(host_id))