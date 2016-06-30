import os
from cloudify import ctx


def _stop_process(pid):
    ctx.logger.info("Going to kill gunicorn process")
    os.system('pkill -f gunicorn.app.wsgiapp')


def main():
    ctx_pid = ctx.instance.runtime_properties['gunicorn_pid']
    ctx.logger.info("Going to stop gunicorn HTTP server, pid {}".format(ctx_pid))
    _stop_process(ctx_pid)


if __name__ == '__main__':
    main()
