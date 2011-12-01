require 'cgi'

module Dropboxr
  
  module Calls

    def get_gallery(path)
      authorized?

      @client.metadata path
    end
    
    def get_galleries(directory = 'Photos')
      authorized?
    
      result = @client.metadata directory
      result["contents"]
    end
    
    def get_photos(gallery)
      authorized?
    
      result = @client.metadata gallery
      result["contents"]
    end
  
    def get_image(path, options={})
      # defaults
      size = options[:size] || ''
      
      # validation
      return nil unless ['small', 'medium', 'large', 'huge', 'original', ''].include? size
    
      # conversion
      size = 'xl' if size == 'huge'
      size = '75x75_fit_one' if size == 'medium'
    
      # http://forums.dropbox.com/topic.php?id=26965&replies=18
    
      authorized?

      path = CGI.escape path
      path.gsub! '+', '%20'
    
      begin
        if size == 'original'
          @client.get_file path
        else
          @client.thumbnail path, size
        end
      rescue DropboxError => e
        p e
        
        nil
      end
    end
    
  end
  
end
