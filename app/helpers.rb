helpers do
  include DropboxrHelpers
  
  def base_url
    @base_url ||= "#{request.env['rack.url_scheme']}://#{request.env['HTTP_HOST']}"
  end
  
  def album_photo(album_id)
    album = Album.find(album_id)
    photo = album.photos.find(:first)
   
    photo.id
  end
  
  def albums_excluding
    albums = Album.all() # Should make sure the 'not in' is in the query or so .... :conditions => {:path => })
    albums.each { |alb| albums.delete(alb) if settings.album_excludes.include? alb.path }

    albums
  end
  
  def protected!
    unless authorized?
      response['WWW-Authenticate'] = %(Basic realm="Dropboxr HTTP Auth")
      
      throw(:halt, [401, "Not authorized!\n"])
    end
  end
  
  def authorized?
    @auth ||= Rack::Auth::Basic::Request.new(request.env)
    @auth.provided? && @auth.basic? && @auth.credentials && @auth.credentials == [settings.auth_login, settings.auth_pass]
  end
  
  def log(message, verbose = false)
    puts message unless verbose
  end
  
  def prev_next_photos(photos, photo_id)
    photo_next = photos[0] if photos.length > 0
    photo_prev = photos[photos.length - 1] if photos.length > 0
    curr_photo = nil
    
    photos.each_with_index do |photo, index|
      if photo.id == photo_id
        photo_prev = photos[index - 1] unless photos[index - 1].nil?
        photo_next = photos[index + 1] unless photos[index + 1].nil?
        
        curr_photo = photo
        
        break
      end
    end
    
    return curr_photo, photo_next, photo_prev
  end
  
  def delete_matching_regexp(dir, regex)
    Dir.entries(dir).each do |name|
      path = File.join(dir, name)
    
      if name =~ regex
        ftype = File.directory?(path) ? Dir : File
        
        begin
          ftype.delete(path)
        rescue SystemCallError => e
          $stderr.puts e.message
        end
      end
    end
  end
end