helpers do
  include DropboxrHelpers
  
  def base_url
    @base_url ||= "#{request.env['rack.url_scheme']}://#{request.env['HTTP_HOST']}"
  end
  
  def album_photo(album_id)
    album = Album.find(album_id)
    photo = album.photos.find(:first)
    
    photo.object_id
  end
  
  def albums_excluding
    albums = Album.all() # Should make sure the 'not in' is in the query or so .... :conditions => {:path => })
    albums.each { |alb| albums.delete(alb) if options.album_excludes.include? alb.path }
    p albums
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
    @auth.provided? && @auth.basic? && @auth.credentials && @auth.credentials == [ENV['AUTH_LOGIN'], ENV['AUTH_PASS']]
  end
  
  def log(message, verbose = false)
    puts message unless verbose
  end
end