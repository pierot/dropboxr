require File.dirname(__FILE__) + '/app'

run Sinatra::Application

#sessioned = Rack::Session::Pool.new(
#	Sinatra::Application,
#	:domain				=> 'wellconsidered.be',
#	:expire_after	=> 60 * 60 * 24 * 365 # expire after 1 year
#)
#
#run sessioned