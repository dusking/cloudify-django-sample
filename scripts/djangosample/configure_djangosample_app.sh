#!/bin/bash

set -e

cd ${VIRTUALENV}
ctx logger info "Starting djangosample migration"
SOURCE_PATH=$(ctx instance runtime_properties source_path)
bin/python ${SOURCE_PATH}/manage.py migrate

ctx logger info "Collect static files..."
bin/python ${SOURCE_PATH}/manage.py collectstatic <<< yes

ctx logger info "Creating django superuser"
echo "from django.contrib.auth.models import User; User.objects.create_superuser('admin', 'me@mail.com', 'pass')" | bin/python ${SOURCE_PATH}/manage.py shell

ctx logger info "Adding some data..."
echo "from polls.models import Question, Choice; from django.utils import timezone; q = Question(question_text='What is new?', pub_date=timezone.now()); q.save(); q.choice_set.create(choice_text='Not much', votes=0); q.choice_set.create(choice_text='Just hacking again', votes=0);" | bin/python ${SOURCE_PATH}/manage.py shell