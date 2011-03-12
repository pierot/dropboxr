require 'sinatra'
require 'timeout'

$: << File.join(File.dirname(__FILE__), '..', 'app')
$: << File.join(File.dirname(__FILE__), '..', 'lib')
$: << File.join(File.dirname(__FILE__), '..', 'vendor')

require 'manifesto-pierot-0.6.2/manifesto-pierot.rb'
require 'dropboxr'
require 'helpers/dropboxrhelpers.rb'

load 'configure.rb'
load 'models.rb'
load 'routes.rb'
load 'helpers.rb'