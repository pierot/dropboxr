require 'rubygems'
require 'sinatra'
require 'less'
require 'memcached'
require 'timeout'

require File.dirname(__FILE__) + '/lib/dropboxr.rb'

use Rack::Session::Pool

configure :development do
  disable :run
  
  set :views, File.dirname(__FILE__) + '/views'
  set :public, File.dirname(__FILE__) + '/public'
  set :app_file, __FILE__
  
  app_vars = YAML.load(File.read('config/dev-vars.yml'))
  
  ENV['DROPBOX_APP_SECRET'] = app_vars['secret']
  ENV['DROPBOX_APP_KEY'] = app_vars['key']
end

configure do
  # Global constants
  CACHE = Memcached.new
  
  # Config files
  albums_excludes = YAML.load(File.read('config/excludes.yml'))
  session_keys = YAML.load(File.read('config/dropbox-session-keys.yml'))
  
  # Sinatra config variables
  set :album_excludes => albums_excludes
  set :mc_img_s => 'imggg_s_', 
      :mc_img_l => 'imggg_l_'
  
  DPC = Dropboxr.new(@base_url, session_keys, ENV['DROPBOX_APP_SECRET'], ENV['DROPBOX_APP_KEY'])
                          
  puts "Sinatra :: Configure do #{DPC}"
end

load 'models.rb'
load 'helpers.rb'
load 'routes.rb'