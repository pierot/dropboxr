require 'rubygems'
require 'sinatra'
require 'less'
require 'memcached'
require 'timeout'
require 'postmark'
require 'tmail'

require File.dirname(__FILE__) + '/dropboxr.rb'

use Rack::Session::Pool

configure :development do
  disable :run
  
  set :views, File.dirname(__FILE__) + '/views'
  set :public, File.dirname(__FILE__) + '/public'
  set :app_file, __FILE__
  
  app_keys = YAML.load(File.read('config/dropbox-app-keys.yml'))
  
  ENV['DROPBOX_APP_SECRET'] = app_keys['secret']
  ENV['DROPBOX_APP_KEY'] = app_keys['key']
end

configure do
  # Global constants
  CACHE = Memcached.new
  
  # Config files
  albums_excludes = YAML.load(File.read('config/excludes.yml'))
  session_keys = YAML.load(File.read('config/dropbox-session-keys.yml'))
  
  # Sinatra config variables
  set :album_excludes => albums_excludes
  set :mc_img_s => 'imgs_s_', 
      :mc_img_l => 'imgs_l_'
  
  DPC = Dropboxr.new(@base_url, session_keys, ENV['DROPBOX_APP_SECRET'], ENV['DROPBOX_APP_KEY'])
                          
  puts "Sinatra :: Configure do #{DPC}"
end

load 'models.rb'
load 'helpers.rb'
load 'routes.rb'