helpers do
  def base_url
    @base_url ||= "#{request.env['rack.url_scheme']}://#{request.env['HTTP_HOST']}"
  end
  
  def load_gallery(gallery)
    album = Album.find_or_create_by_path(gallery.path)

    if album.modified != gallery.modified
      puts "Gallery :: Creating #{gallery.path} modified on: #{gallery.modified} <> #{album.modified}" # -> (#{gallery.inspect})"

      photos = DPC.get_photos gallery.path

      photos.each do |item|
        if defined? item.mime_type && item.mime_type == "image/jpeg"
          unless photo = album.photos.find_by_path(item.path)
            load_photo(album, item)
            
            album.save
          end
        end
      end
      
      album.modified = gallery.modified
      album.save
    end
  end

  def load_photo(album, item)
    path = DPC.get_link item.path
    path.sub!(/\/dropbox/, "") # remove dropbox from path for direct linking

    photo = album.photos.create(  :name => path.scan(/\w+\.\w+$/)[0],
                                  :path => "/#{item.path}", 
                                  :link => path, 
                                  :revision => item.revision, :modified => item.modified)

    puts "Photo :: Creating #{photo.path} ..."
  end
end