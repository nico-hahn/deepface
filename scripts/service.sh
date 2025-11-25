#!/usr/bin/env bash
cd ../deepface/api/src

# run the service with flask - not for production purposes
# python api.py

# run the service with gunicorn - for prod purposes
gunicorn --workers=1 --timeout=3600 --bind=0.0.0.0:5005 --log-level=debug --access-logformat='%(h)s - - [%(t)s] "%(r)s" %(s)s %(b)s %(L)s' "app:create_app()"