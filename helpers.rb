helpers do
  def base_url
    @base_url ||= "#{request.env['rack.url_scheme']}://#{request.env['HTTP_HOST']}"
  end
  
  def load_gallery(gallery)
    puts "Gallery :: Finding #{gallery.path} in db"
    
    album = Album.find_or_create_by_path(gallery.path)

    if album.modified != gallery.modified
      puts "Gallery :: Creating or Updating #{gallery.path} modified on: #{gallery.modified} <> #{album.modified}" # -> (#{gallery.inspect})"

      # saving in session
      session[:galleries_photos][album.id] = DPC.get_photos gallery.path if session[:galleries_photos][album.id].nil?
      photos = session[:galleries_photos][album.id]

      photos.each do |item|
        if defined? item.mime_type && item.mime_type == "image/jpeg"
          photo = album.photos.find_or_create_by_path(item.path)
          
          if photo.name.nil? || photo.modified != item.modified
            if photo.name.nil? # new
              photo.name = item.path.scan(/(\w|[-.])+$/)[0]
              photo.path = item.path
              photo.link = "" # DPC.get_link item.path
              
              puts "Photo :: Creating #{photo.path} ..."
            else # resetting images
              puts "Photo :: Updating #{photo.path} ..."
            end
            
            photo.img_small = nil
            photo.img_large = nil
          
            photo.revision = item.revision
            photo.modified = item.modified
            
            #photo.save
            #album.save
          end
        end
      end
      
      album.modified = gallery.modified
      #album.save
    end
  end
end