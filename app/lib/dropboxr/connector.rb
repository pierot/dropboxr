require 'dropbox_sdk'

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

        Dropboxr.connection = Dropboxr::Connector.new :key => Dropboxr::Application.config.dbr_key, 
                                                      :secret => Dropboxr::Application.config.dbr_secret, 
                                                      :session_key => session_key
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
          @session.authorized?
        else
          false
        end
      end
    end

    def authorize_user_url
      @session = DropboxSession.new @key, @secret

      @session.get_authorize_url(redirect_url)
    end
    
    def authorize_user
      unless @session.nil?
        @session.get_access_token
  
        create_client
        
        @session_serialized = @session.serialize
      end
      
      authorized?
    end
  
    private

    def create_client
      @client = DropboxClient.new @session, :dropbox
    end
  
    def authorize!
      puts "Dropboxr::Connector Authorizing!"
    
      unless @session_serialized.nil? || @session_serialized.empty?
        @session = DropboxSession.deserialize(@session_serialized)

        create_client
      end
    end
    
  end
  
end
