require 'rubygems'
require 'sinatra'
require 'less'
require 'memcached'

require 'dropboxr.rb'    

#result = Sinatra::Cache.cache(cache_key) do
#    this_is_an_expensive_method
#end

configure do
  puts "Sinatra :: Configure do"
  
  CACHE = Memcached.new
  
  set :mc_img_s => 'img_s_', 
      :mc_img_l => 'img_l_', 
      :mc_album => 'alb_', 
      :mc_albums => 'albs_'
  
  DPC = Dropboxr.new( 'http://www.wellconsidered.be/', # dummy url for redirect
                      'config/dropbox-key.txt', # session key file 
                      'ysr84fd8hy49v9k', # secret
                      'oxye3gyi03lqmd4') # key
                                
  puts "Sinatra :: #{DPC}"
end

load 'models.rb'
load 'routes.rb'