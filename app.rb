require 'rubygems'
require 'sinatra'
require 'less'
require 'memcached'
require 'timeout'
require 'manifesto-pierot'

require File.dirname(__FILE__) + '/lib/dropboxr.rb'

use Rack::Session::Pool

configure :development do
  disable :run
  
  set :views, File.dirname(__FILE__) + '/views'
  set :public, File.dirname(__FILE__) + '/public'
  set :app_file, __FILE__
  
  app_vars = YAML.load(File.read('config/dev-vars.yml'))
  
  ENV['DROPBOX_APP_SECRET'] = app_vars['secret'] # local
  ENV['DROPBOX_APP_KEY'] = app_vars['key'] # local
end

configure do
  # Global constants
  CACHE = Memcached.new
  
  # Mime Types
  mime_type :ttf, 'font/ttf'
  mime_type :woff, 'font/woff'
  mime_type :manifest, 'text/cache-manifest'
  
  # Config files
  albums_excludes = YAML.load(File.read('config/excludes.yml'))
  session_keys = YAML.load(File.read('config/dropbox-session-keys.yml'))
  
  # Sinatra config variables
  set :album_excludes => albums_excludes
  set :mc_img_s => 'img_ss_', 
      :mc_img_l => 'img_sl_'
  
  DPC = Dropboxr.new(@base_url, session_keys, ENV['DROPBOX_APP_SECRET'], ENV['DROPBOX_APP_KEY'])
                          
  puts "Sinatra :: Configure do #{DPC}"
end

load 'models.rb'
load 'helpers.rb'
load 'routes.rb'