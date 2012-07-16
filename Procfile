web: bundle exec thin start -p $PORT
job: bundle exec rake resque:workers COUNT=3 QUEUE=* VERBOSE=1 
