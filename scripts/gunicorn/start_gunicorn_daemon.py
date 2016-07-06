import os
import subprocess
from cloudify import ctx


def main():
    env_path = os.environ.get('VIRTUALENV')
    if not env_path:
        raise Exception('missing VIRTUALENV')
    ctx.logger.info("Going to start gunicorn HTTP server, env_path: ({0})".format(env_path))
    django_project_path = os.path.join(os.path.expanduser('~'), 'djangosample/src/')
    sockfile_path = os.path.join(django_project_path, 'mysite/mysite.sock')
    process_args = [
        os.path.join(env_path, 'bin/python'),
        '-m', 'gunicorn.app.wsgiapp',
        '--bind', 'unix:{0}'.format(sockfile_path),
        'mysite.wsgi:application',
        '--chdir', django_project_path
    ]
    ctx.logger.info("Going to run gunicorn: {0}".format(' '.join(process_args)))
    process = subprocess.Popen(process_args,
                               stdout=open('/tmp/gunicorn_config.stdout', 'w'),
                               stderr=open('/tmp/gunicorn_config.stderr', 'w'))
    if process.returncode is not None:
        raise Exception('Process finished with return-code: {0}'.format(process.returncode))
    ctx.logger.info("Successfully started gunicorn HTTP Server ({0})".format(process.pid))


if __name__ == '__main__':
    main()
