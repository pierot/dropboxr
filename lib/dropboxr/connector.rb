require 'dropbox'

module Dropboxr

  class Connector
    
    include Calls
    include Collector
    
    attr_accessor :redirect_url, :directory_excludes, :cache
    
    def initialize(session_key, secret, key)
      # session key from yml file
      @session_serialized = ""
      session_key.each { |line| @session_serialized << "- #{line}\n" }
      @session_serialized = "--- \n#{@session_serialized}"
    
      @secret = secret
      @key = key
      
      directory_excludes = []
      redirect_url = ''
      cache = false
    end
   
    def authorized?
      if !@session.nil? && @session.authorized?
        true
      else
        authorize!
    
        @session.mode = :dropbox if @session.authorized?
        @session.authorized?
      end
    end
  
    def authorize_user
      @session = Dropbox::Session.new(@secret, @key)
    
      @session.authorize_url(:oauth_callback => redirect_url)
    end
  
    private
  
    def authorize!
      puts "Dropboxr::Connector.Authorizing!"
    
      unless @session_serialized.nil? || @session_serialized.empty?
        @session = Dropbox::Session.deserialize(@session_serialized)
      end
    
      @session.enable_memoization if cache
    end
    
  end
  
end