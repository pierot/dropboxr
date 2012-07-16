web: bundle exec thin start -p $PORT
job: bundle exec rake resque:workers VERBOSE=1 COUNT=2 QUEUE=* 
