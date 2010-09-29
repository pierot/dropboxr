require 'rubygems'
require 'sinatra'
require 'less'
require 'dalli'
require 'timeout'

require File.dirname(__FILE__) + '/dropboxr.rb'

use Rack::Session::Pool

configure :development do # Needed to do this for local dev
  disable :run
  
  set :views, File.dirname(__FILE__) + '/views'
  set :public, File.dirname(__FILE__) + '/public'
  set :app_file, __FILE__
end

configure do
  # Global constants
  CACHE = Dalli::Client.new 
  
  # Config files
  albums_excludes = YAML.load(File.read('config/excludes.yml'))
  session_keys = YAML.load(File.read('config/dropbox-session-keys.yml'))
  app_keys = YAML.load(File.read('config/dropbox-app-keys.yml'))
  
  # Sinatra config variables
  set :album_excludes => albums_excludes
  set :mc_img_s => 'imgss_s_', 
      :mc_img_l => 'imgss_l_'
  
  DPC = Dropboxr.new(@base_url, session_keys, app_keys['secret'], app_keys['key'])
                          
  puts "Sinatra :: Configure do #{DPC}"
end

load 'models.rb'
load 'helpers.rb'
load 'routes.rb'