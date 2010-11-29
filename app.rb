require 'sinatra'
require 'memcached'
require 'timeout'

$: << File.join(File.dirname(__FILE__), 'lib')
$: << File.join(File.dirname(__FILE__), 'vendor')

require 'manifesto-pierot-0.6.2/manifesto-pierot.rb'
require 'dropboxr'

load 'app/configure.rb'
load 'app/models.rb'
load 'app/helpers.rb'
load 'app/routes.rb'