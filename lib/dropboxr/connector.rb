require 'dropbox'

module Dropboxr

  class Connector
    
    include Calls
    include Collector
    
    attr_accessor :redirect_url, :directory_excludes, :cache
    
    def initialize(session_key_file, secret, key)
      @secret = secret
      @key = key
      @session_key_file = session_key_file
      
      directory_excludes = []
      redirect_url = ''
      cache = false
      
      if File.exists?(@session_key_file)
        session_key = YAML.load File.read(@session_key_file)
        
        # session key from yml file
        @session_serialized = ""
        session_key.each { |line| @session_serialized << "- #{line}\n" }
        @session_serialized = "--- \n#{@session_serialized}"
      else
        # not authorized yet, no session keys found
      end
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
      unless @session.nil?
        @session.authorize(params)
        
        File.open(@session_key_file, 'w+') { |f| f.write(@session.serialize) }
        
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
        @session = Dropbox::Session.deserialize(@session_serialized)
      end
    
      @session.enable_memoization if cache
    end
    
  end
  
end