require 'dropbox'

module Dropboxr

  class Connector
    
    include Calls
    include Collector
    
    def initialize(redirect_url, session_key, secret, key)
      @redirect_url = redirect_url
    
      # session key from yml file
      @session_serialized = ""
      session_key.each { |line| @session_serialized << "- #{line}\n" }
      @session_serialized = "--- \n#{@session_serialized}"
    
      @secret = secret
      @key = key
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
    
      @session.authorize_url(:oauth_callback => @redirect_url)
    end
  
    private
  
    def authorize!
      puts "DropboxConnector :: Authorizing!"
    
      unless @session_serialized.nil? || @session_serialized.empty?
        @session = Dropbox::Session.deserialize(@session_serialized)
      end
    
      @session.enable_memoization
    end
    
  end
  
end