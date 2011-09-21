require 'dropbox'

module Dropboxr

  class Connector
    
    include Calls
    include Collector
    
    attr_accessor :redirect_url, :directory_excludes, :cache, :session_serialized
    
    def initialize(key = '', secret = '', session_key = '')
      @secret = secret
      @key = key

      @session_serialized = session_key
      
      directory_excludes = []
      redirect_url = ''
      cache = false
    end
   
    def authorized?
      if !@session.nil? && @session.authorized?
        true
      else
        authorize!
    
        unless @session.nil?
          setup_mode
          
          @session.authorized?
        else
          false
        end
      end
    end
  
    def authorize_user_url
      @session = Dropbox::Session.new(@secret, @key)
    
      @session.authorize_url(:oauth_callback => redirect_url)
    end
    
    def authorize_user(params)
      p @session
      unless @session.nil?
        @session.authorize(params)
        
        @session_serialized = @session.serialize
        
        setup_mode
      end
      
      authorized?
    end
  
    private
    
    def setup_mode
      @session.mode = :dropbox if @session.authorized?
    end
  
    def authorize!
      puts "Dropboxr::Connector.Authorizing!"
    
      unless @session_serialized.nil? || @session_serialized.empty?
        @session = Dropbox::Session.deserialize(session_serialized)
      end
    
      @session.enable_memoization if cache unless @session.nil?
    end
    
  end
  
end
