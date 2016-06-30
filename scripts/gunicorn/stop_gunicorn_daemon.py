import os
from cloudify import ctx


def _stop_process():
    ctx.logger.info("Going to kill gunicorn process")
    os.system('pkill -f gunicorn.app.wsgiapp')


def main():
    ctx.logger.info("Going to stop gunicorn HTTP server")
    _stop_process()


if __name__ == '__main__':
    main()
