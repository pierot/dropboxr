require 'dropbox'

class Dropboxr
  attr_reader :session
  
  def initialize(redirect_url, session_key, secret, key)
    puts "**********"
    session_key.each {|line| @session_serialized += "- " + line + "\n"}
    puts "**********"
    @redirect_url = redirect_url
    @session_serialized = "--- \n" + @session_serialized
    puts @session_serialized
    @secret = secret
    @key = key
  end
  
  def connect
    if !@session.nil? && !@session.authorized?
      #puts "DropboxConnector :: Connect OK"
      
      true
    else
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
    connect
    
    @session.list directory
  end
  
  def get_photos(gallery)
    connect
    
    @session.list gallery #, {suppress_list: true}
  end
  
  def get_link(path)
    connect
    
    @session.link path
  end
  
  def get_image(path, size = '')
    return nil unless ['s', 'm', 'l', ''].include? size
    
    connect
    
    @session.thumbnail path, size
  end
  
  private
  
  def authorize
    #puts "DropboxConnector :: Authorize"
    
    if @session_serialized.nil? || @session_serialized.empty?
      @session = Dropbox::Session.new(@secret, @key)
      @session.enable_memoization
      
      puts "DropboxConnector :: Visit #{session.authorize_url(:oauth_callback => @redirect_url)} to log in to Dropbox."
      puts "DropboxConnector :: Hit enter when you have done this."
      gets

      puts "DropboxConnector :: Copy the session key below, paste it in the config/key.yml."
      puts @session.serialize
    else
      #puts "DropboxConnector :: We still have your session. It is being loaded right now." # #{@session_serialized}"

      @session = Dropbox::Session.deserialize(@session_serialized)
      @session.enable_memoization
    end
  end
end