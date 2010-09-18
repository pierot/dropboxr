require 'dropbox'

class DropboxConnector
  attr_reader :session
  
  def initialize(redirect_url, session_file, secret, key)
    @redirect_url = redirect_url
    @session_file = session_file
    @secret = secret
    @key = key
  end
  
  def connect
    @session_serialized = fetch_saved_session
    
    authorize
    
    if @session.authorized?
      puts "DropboxConnector :: All ok"

      @session.mode = :dropbox
      
      true
    else
      false
    end
  end
  
  private
  
  def fetch_saved_session
    @session_saver = File.new(@session_file, "r+")
    
    serialized = ""

    while key_line = @session_saver.gets
      serialized += key_line
    end

    serialized
  end
  
  def authorize
    if @session_serialized.nil? || @session_serialized.empty?
      @session = Dropbox::Session.new(@secret, @key)

      puts "DropboxConnector :: Visit #{session.authorize_url(:oauth_callback => @redirect_url)} to log in to Dropbox."
      puts "DropboxConnector :: Hit enter when you have done this."
      gets

      if @session.authorize
        @session_serialized = @session.serialize

        @session_saver.write(@session_serialized)
        @session_saver.close
      end
    else
      puts "DropboxConnector :: We still have your session. It is being loaded right now." # #{@session_serialized}"

      @session = Dropbox::Session.deserialize(@session_serialized)
    end
  end
end