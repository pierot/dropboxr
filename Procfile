web: bundle exec thin start -p $PORT
job: COUNT=3 QUEUE=* bundle exec rake resque:work
