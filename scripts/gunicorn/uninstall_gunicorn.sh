#!/bin/bash

set -e

ctx logger info "Going to uninstall gunicorn"
pip uninstall -y gunicorn