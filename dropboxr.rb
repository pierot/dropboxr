require 'dropbox'

class Dropboxr
  attr_reader :session
  
  def initialize(redirect_url, session_file, secret, key)
    @redirect_url = redirect_url
    @session_file = session_file
    @secret = secret
    @key = key
  end
  
  def connect
    if !@session.nil? && !@session.authorized?
      #puts "DropboxConnector :: Connect OK"
      
      true
    else
      @session_serialized = fetch_saved_session
    
      authorize
    
      if @session.authorized?
        #puts "DropboxConnector :: Connect OK 2"

        @session.mode = :dropbox
      
        true
      else
        #puts "DropboxConnector :: Connect NOK!!"
        
        false
      end
    end
  end
  
  def get_galleries(directory = 'Photos')
    @session.list directory
  end
  
  def get_photos(gallery)
    @session.list gallery #, {suppress_list: true}
  end
  
  def get_link(path)
    @session.link path
  end
  
  def get_image(path, size = '')
    return nil unless ['s', 'm', 'l', ''].include? size
    
    @session.thumbnail path, size
  end
  
  private
  
  def fetch_saved_session
    #puts "DropboxConnector :: Fetch Saved Session"
    
    @session_saver = File.new(@session_file, "r") #+")
    
    serialized = ""

    while key_line = @session_saver.gets
      serialized += key_line
    end

    serialized
  end
  
  def authorize
    #puts "DropboxConnector :: Authorize"
    
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
      #puts "DropboxConnector :: We still have your session. It is being loaded right now." # #{@session_serialized}"

      @session = Dropbox::Session.deserialize(@session_serialized)
      #@session.enable_memoization
    end
  end
end