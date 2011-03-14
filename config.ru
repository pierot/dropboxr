require 'bundler'
require './app/app'
 
unless ENV['RACK_ENV'] == 'development'
	log = File.new('tmp/sinatra.log', 'a+')
	log.sync = true
	
	STDOUT.reopen(log)
	STDERR.reopen(log)
end

run Sinatra::Application