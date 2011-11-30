require 'dropbox'

module Dropboxr

  class << self
    attr_accessor :connection
  end

  class Connector
    
    include Calls
    include Collector
    
    attr_accessor :redirect_url, :directory_excludes, :cache, :session_serialized

    def self.connection
      if Dropboxr.connection.nil?
        puts "Dropboxr::Connector Create Connection"

        session_key = Installation.installed.first.session_key unless Installation.installed.empty?

        Dropboxr.connection = Dropboxr::Connector.new :key => Dropboxr::Application.config.dbr_key, :secret => Dropboxr::Application.config.dbr_secret, :session_key => session_key
      end

      Dropboxr.connection
    end
    
    def initialize(options = {})
      @secret ||= options[:secret]
      @key ||= options[:key]

      @session_serialized ||= options[:session_key]
      
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
      @session = Dropbox::Session.new(@key, @secret, {:ssl => true})
    
      @session.authorize_url(:oauth_callback => redirect_url)
    end
    
    def authorize_user(params)
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
      puts "Dropboxr::Connector Authorizing! #{@session_serialized}"
    
      unless @session_serialized.nil? || @session_serialized.empty?
        @session = Dropbox::Session.deserialize(@session_serialized)
      end
    
      @session.enable_memoization if cache unless @session.nil?
    end
    
  end
  
end
