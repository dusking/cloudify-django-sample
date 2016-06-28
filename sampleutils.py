#!/usr/bin/env python

import glob
import shlex
import subprocess
import tempfile
from jinja2 import Template

from cloudify import ctx


def create_folder(name):
    sudo(['mkdir', '-p', name])


def copy(source, destination):
    sudo(['cp', '-rp', source, destination])


def sudo(command, retries=0, globx=False, ignore_failures=False):
    if isinstance(command, str):
        command = shlex.split(command)
    command.insert(0, 'sudo')
    return run(command=command, globx=globx, retries=retries,
               ignore_failures=ignore_failures)


def run(command, retries=0, ignore_failures=False, globx=False):
    if isinstance(command, str):
        command = shlex.split(command)
    stderr = subprocess.PIPE
    stdout = subprocess.PIPE
    if globx:
        glob_command = []
        for arg in command:
            glob_command.append(glob.glob(arg))
        command = glob_command
    # ctx.logger.debug('Running: {0}'.format(command))
    proc = subprocess.Popen(command, stdout=stdout, stderr=stderr)
    proc.aggr_stdout, proc.aggr_stderr = proc.communicate()
    if proc.returncode != 0:
        command_str = ' '.join(command)
        if retries:
            # ctx.logger.warn('Failed running command: {0}. Retrying. ' '({1} left)'.format(command_str, retries))
            proc = run(command, retries - 1)
        elif not ignore_failures:
            msg = 'Failed running command: {0} ({1}).'.format(
                command_str, proc.aggr_stderr)
            raise RuntimeError(msg)
    return proc


def download_resource_and_render(source, destination, params):
    ctx.logger.info('Downloading resource {0} to {1}'.format(source, destination))
    template = Template(ctx.get_resource(source))

    ctx.logger.debug('The config dict for the Jinja2 template: {0}.'.format(params))

    ctx.logger.debug('Rendering the Jinja2 template to {0}.'.format(destination))
    with tempfile.NamedTemporaryFile(delete=False) as temp_config:
        temp_config.write(template.render(params))
    sudo(['mv', temp_config.name, destination])

    ctx.logger.debug('Great success')
