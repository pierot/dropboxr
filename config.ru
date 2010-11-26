require 'rubygems'
require 'bundler'

$: << File.join(File.dirname(__FILE__), 'lib')
$: << File.join(File.dirname(__FILE__), 'vendor')

# Bundler.require
# Bundler.setup

require './app'

run Sinatra::Application