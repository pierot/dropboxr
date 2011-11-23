module Dropboxr
  
  module Calls
    
    def get_galleries(directory = 'Photos')
      authorized?
    
      @session.list directory
    end
    
    def get_photos(gallery)
      authorized?
    
      @session.list gallery #, {suppress_list: true}
    end
  
    def get_link(path)
      authorized?
    
      @session.link path
    end
  
    def get_image(path, options={})
      # defaults
      size = options[:size] || ''
      format = options[:format] || ''
      
      # validation
      return nil unless ['small', 'medium', 'large', 'huge', 'original', ''].include? size
      return nil unless ['JPEG', 'PNG', ''].include? format
    
      # conversion
      size = 'xl' if size == 'huge'
      size = '75x75_fit_one' if size == 'medium'
    
      # http://forums.dropbox.com/topic.php?id=26965&replies=18
    
      authorized?
    
      begin
        if size == 'original'
          @session.download path
        else
          @session.thumbnail path, {:size => size, :format => format}
        end
      rescue Dropbox::UnsuccessfulResponseError => e
        p e
        
        nil
      end
    end
    
  end
  
end
