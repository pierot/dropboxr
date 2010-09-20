##!/usr/bin/ruby

require 'rubygems'
require 'sinatra'
require 'less'
require 'memcached'

require './lib/dropboxr.rb'    

#result = Sinatra::Cache.cache(cache_key) do
#    this_is_an_expensive_method
#end

configure do
  puts "Sinatra :: Configure do"
  
  CACHE = Memcached.new
  
  #set :dbname, 'devdb' # Variable set for all blocks
  
  DPC = Dropboxr.new(  'http://www.wellconsidered.be/', 
                                'config/dropbox-key.txt', 
                                'ysr84fd8hy49v9k', 
                                'oxye3gyi03lqmd4')
                                
  puts "Sinatra :: #{DPC}"
end

load 'models.rb'
load 'routes.rb'