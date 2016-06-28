import os
import socket
import time
import subprocess

from cloudify import ctx


def _port_available(port):
    s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    try:
        s.bind(('0.0.0.0', port))
        return True
    except:
        return False
    finally:
        s.close()


def _verify_server_up(process, server_name):
    if process.returncode is not None:
        ctx.logger.error('Process {} finished with return-code: {}'.format(server_name, process.returncode))
        raise Exception('Process {} finished with return-code: {}'.format(server_name, process.returncode))


def _set_runtime_properties(pid):
    ctx.instance.runtime_properties['gunicorn_pid'] = pid


def main():
    try:
        env_path = os.environ.get('VIRTUALENV', None)
        ctx.logger.info("Going to start gunicorn HTTP server, env_path: ({})".format(env_path))
        django_project_path = '/home/vagrant/djangosample/src/'
        sockfile_path = '/home/vagrant/djangosample/src/mysite/mysite.sock'
        process_args = [
            os.path.join(env_path, 'bin/python'),
            '-m', 'gunicorn.app.wsgiapp',
            '--bind', 'unix:{}'.format(sockfile_path),
            'mysite.wsgi:application',
            '--chdir', django_project_path
        ]
        ctx.logger.info("Going to run gunicorn: {}".format(' '.join(process_args)))
        process = subprocess.Popen(process_args,
                                   stdout=open(os.path.join('/tmp', 'gunicorn_config.stdout'), 'w'),
                                   stderr=open(os.path.join('/tmp', 'gunicorn_config.stderr'), 'w'))
        _verify_server_up(process, 'Gunicorn')
        _set_runtime_properties(process.pid)
        ctx.logger.info("Successfully started gunicorn HTTP Server ({})".format(process.pid))
    except:
        ctx.logger.exception('failed')
        raise


if __name__ == '__main__':
    main()
