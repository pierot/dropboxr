require 'memcache'
require 'digest/md5'

module Sinatra
  class Cache
    def self.cache(key, &block)
      unless CONFIG['memcached']
        raise "Configure CONFIG['memcached'] to be a string like 'localhost:11211' "
      end
      begin
        key = Digest::MD5.hexdigest(key)
        @@connection ||= MemCache.new(CONFIG['memcached'], :namespace => 'Sinatra/')
        result = @@connection.get(key)
        return result if result
        result = yield
        @@connection.set(key, result)
        result
      rescue
        yield
      end
    end
  end
end

module CacheableEvent
  def self.included(base)
    base.send :include, CacheableEvent::InstanceMethods
    base.class_eval do
      alias_method :_invoke_without_caching, :invoke unless method_defined?(:_invoke_without_caching)
      alias_method :invoke, :_invoke_with_caching   
    end
  end
  
  module InstanceMethods
    def _invoke_with_caching(*args)
      if options[:cache_key]
        # replace the block with another block that can be cached
        def wrap_block(key,block)
          Proc.new do
            Sinatra::Cache.cache(key + "/" + params.to_a.join("/")) { instance_eval(&block) }
          end
        end
        @block = wrap_block(options[:cache_key], block)
      end
      _invoke_without_caching(*args)
    end
  end
  
end

