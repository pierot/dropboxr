require 'bundler'

# Bundler.require
# Bundler.setup

require './app/app'

# Sinatra::Application.default_options.merge!(
#   :run => false,
#   :env => :production,
#   :raise_errors => true
# )
 
if ENV['RACK_ENV'] == 'production'
	log = File.new('tmp/sinatra.log', 'a+')
	
	STDOUT.reopen(log)
	STDERR.reopen(log)
end

run Sinatra::Application