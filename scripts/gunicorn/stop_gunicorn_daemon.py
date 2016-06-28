import os
from signal import SIGKILL

from cloudify import ctx


def _stop_process(pid):
    try:
        ctx.logger.info("Going to kill gunicorn process")
        # os.system('pkill -TERM -P {pid}'.format(pid=pid))
        os.system('pkill -f gunicorn.app.wsgiapp')

    except Exception, e:
        ctx.logger.exception('stop process failed with exception: {}'.format(e))


def main():
    try:
        ctx_pid = ctx.instance.runtime_properties['gunicorn_pid']
        ctx.logger.info("Going to stop gunicorn HTTP server, pid {}".format(ctx_pid))
        _stop_process(ctx_pid)
    except:
        ctx.logger.exception('stop gunicorn process failed')
        raise


if __name__ == '__main__':
    main()
