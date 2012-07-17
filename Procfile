web:    bundle exec thin start -p $PORT
worker: bundle exec rake resque:workers COUNT=3 QUEUE=* VVERBOSE=1
