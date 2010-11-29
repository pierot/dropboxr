require 'sinatra'
require 'memcached'
require 'timeout'

$: << File.join(File.dirname(__FILE__), '..', 'lib')
$: << File.join(File.dirname(__FILE__), '..', 'vendor')

require 'manifesto-pierot-0.6.2/manifesto-pierot.rb'
require 'dropboxr'

use Rack::Session::Pool

configure :development do
  disable :run
  
  app_vars = YAML.load(File.read('config/dev-vars.yml'))
  
  ENV['DROPBOX_APP_SECRET'] = app_vars['secret'] # local
  ENV['DROPBOX_APP_KEY'] = app_vars['key'] # local
  
  ENV['AUTH_LOGIN'] = app_vars['login'] # local
  ENV['AUTH_PASS'] = app_vars['pass'] # local
end

configure do
  set :root, File.join(File.dirname(__FILE__), '..')
  
  # Global constants
  CACHE = Memcached.new
  
  # Mime Types
  mime_type :ttf, 'font/ttf'
  mime_type :woff, 'font/woff'
  mime_type :eot, 'font/eot'
  mime_type :manifest, 'text/cache-manifest'
  mime_type :less, 'text/plain'
  
  # Config files
  albums_excludes = YAML.load(File.read('config/excludes.yml'))
  session_keys = YAML.load(File.read('config/dropbox-session-keys.yml'))
  
  # Sinatra config variables
  set :album_excludes => albums_excludes
  set :mc_img => 'img_s_'
  
  DPC = Dropboxr::Connector.new(@base_url, session_keys, ENV['DROPBOX_APP_SECRET'], ENV['DROPBOX_APP_KEY'])
                          
  puts "Sinatra :: Configure do #{DPC}"
end