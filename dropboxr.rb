require 'dropbox'

class Dropboxr
  def initialize(redirect_url, session_key, secret, key)
    @redirect_url = redirect_url
    
    # session key from yml file
    @session_serialized = ""
    session_key.each {|line| @session_serialized << "- #{line}\n"}
    @session_serialized = "--- \n#{@session_serialized}"
    puts @session_serialized
    
    @secret = secret
    @key = key
  end
  
  def connect
    if !@session.nil? && @session.authorized?
      true
    else
      authorize
    
      if @session.authorized?
        @session.mode = :dropbox
      end
      
      @session.authorized?
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
    puts "DropboxConnector :: Authorizing!"
    
    if @session_serialized.nil? || @session_serialized.empty?
      @session = Dropbox::Session.new(@secret, @key)
      
      puts "DropboxConnector :: Visit #{session.authorize_url(:oauth_callback => @redirect_url)} to log in to Dropbox."
      puts "DropboxConnector :: Hit enter when you have done this."
      gets

      puts "DropboxConnector :: Copy the session key below, paste it in the config/key.yml."
      puts @session.serialize
    else
      @session = Dropbox::Session.deserialize(@session_serialized)
    end
    
    #@session.enable_memoization
  end
end