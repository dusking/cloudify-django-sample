#!/usr/bin/env python

from cloudify import ctx

ctx.logger.info('DjangoSample - Setting Host IP Runtime Property.')
host_id = ctx.target.instance.runtime_properties['host_id']
ctx.logger.info('Host ID is: {0}'.format(host_id))
ctx.source.instance.runtime_properties['host_id'] = host_id
ctx.logger.info('DjangoSample - Host IP Runtime Property been set.')