require 'rubygems'
require 'sinatra'
require 'less'
require 'memcached'
require 'timeout'

require File.dirname(__FILE__) + '/dropboxr.rb'

enable :sessions

# Needed to do this for local dev
configure :development do
  disable :run
  
  set :views, File.dirname(__FILE__) + '/views'
  set :public, File.dirname(__FILE__) + '/public'
  set :app_file, __FILE__
end

configure do
  puts "Sinatra :: Configure do"
  
  CACHE = Memcached.new
  
  set :mc_img_s => 'imgss_s_', 
      :mc_img_l => 'imgss_l_', 
      :mc_album => 'albuu_', 
      :mc_albums => 'albss_'
      
  set :album_excludes => YAML.load(File.read('config/excludes.yml'))
  
  DPC = Dropboxr.new( 'http://www.wellconsidered.be/', # dummy url for redirect
                      YAML.load(File.read('config/key.yml')), # session key file 
                      'ysr84fd8hy49v9k', # secret
                      'oxye3gyi03lqmd4') # key
                                
  puts "Sinatra :: #{DPC}"
end

load 'models.rb'
load 'helpers.rb'
load 'routes.rb'

#result = Sinatra::Cache.cache(cache_key) do
#    this_is_an_expensive_method
#end