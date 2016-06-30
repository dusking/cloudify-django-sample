#!/bin/bash

# This script is running as postgres user
# As if the first line was: sudo su - postgres

set -e

psql -c "CREATE DATABASE mysite"
psql -c "CREATE USER mysiteuser WITH PASSWORD 'password'"
psql -c "GRANT ALL PRIVILEGES ON DATABASE mysite TO mysiteuser"