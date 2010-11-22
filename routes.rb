#########################################################################################################
# VARIOUS
#########################################################################################################
before do
  #headers['Cache-Control'] = 'public, max-age=172800' # Two days
  
  if :agent.to_s =~ /(Slurp|msnbot|Googlebot)/ # bots not allowed
    redirect 'http://wellconsidered.be'
  end
end

error do
  'Sorry there was a nasty error - ' + request.env['sinatra.error'].name
end

not_found do
  'Sorry - Not Found'
end

get '/css/style.css' do
  content_type 'text/css', :charset => 'utf-8'
  
  less :'css/style'
end

get '/timecheck' do
  session[:time] = Time.new if session[:time].nil?
  
  "Current Time : " + session[:time].inspect
end

get '/manifest' do
  headers 'Content-Type' => 'text/cache-manifest' # Must be served with this MIME type
  
  files = []
  
  albums = albums_excluded
  albums.each do |album|
    album.photos.each do |photo|
      files << "/thumb/#{photo.id}"
      files << "/image/#{photo.id}"
    end
  end
  
  Manifesto.cache :files => files
end

#########################################################################################################
# BUILDING / SETUP
#########################################################################################################
['/build/building/?', '/build/building/*'].each do |path|
  get path do
    redirect '/build/error' unless DPC.connect
    
    unless session[:galleries].nil?
      log "Session is present.", true
    end
    
    session[:galleries] = DPC.get_galleries if session[:galleries].nil? # Fetch from session, reduce Dropbox calls
    galleries = session[:galleries]
    
    session[:galleries_photos] = {} if session[:galleries_photos].nil?
    
    log "Rebuilding #{galleries.length} galleries.", true
    
    begin
      Timeout::timeout(20) do
        galleries.each { |gallery| load_gallery gallery if gallery.directory? && !(options.album_excludes.include? gallery.path) }
      end
    rescue Timeout::Error
      log "Rebuilding took too long. We'll continue after the break.", true
      
      redirect "/build/building/#{rand(99999999999)}"
    end
    
    redirect '/build/done'
  end
end

get '/build/:state' do
  case params[:state]
  when 'done'
    @redirect_url = '/'
    
    erb :'build/done'
  when 'start'
    @redirect_url = '/build/building/'
    
    erb :'build/start'
  when 'error'
    erb :'build/error'
  else
    redirect '/'
  end
end

#########################################################################################################
# BASE PAGES
#########################################################################################################
get '/' do
  @albums = albums_excluded
  
  redirect '/empty' if @albums.length == 0
  
  erb :index
end

get '/empty' do
  erb :empty
end

get '/gallery/:album' do
  begin
    @album = Album.find(params[:album])
  rescue ActiveRecord::RecordNotFound
    redirect '/'
  end
  
  @photos = @album.photos.each

  erb :gallery
end

get '/gallery/:album/image/:id' do 
    begin
      @album = Album.find(params[:album])
      # @photo = @album.photos.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect '/' # back
    end
    
    @photos = @album.photos 
    @photo_next = @photos[0] if @photos.length > 0
    @photo_prev = @photos[@photos.length - 1] if @photos.length > 0
    
    @photos.each_with_index do |photo, index|
      if photo.id == params[:id].to_i
        @photo_prev = @photos[index - 1] unless @photos[index - 1].nil?
        @photo_next = @photos[index + 1] unless @photos[index + 1].nil?
        
        @photo = photo
        
        break
      end
    end
    
    redirect '/' if @photos.length == 0 || @photo.nil?
    
    erb :image
end

#########################################################################################################
# IMAGES
#########################################################################################################
get '/thumb/:id' do 
  content_type 'image/jpeg'
  
  begin
    image = CACHE.get(options.mc_img_s + params[:id])
  rescue Memcached::Error
    image_item = Photo.find(params[:id])
    image = image_item.img_small

    if image.nil? && DPC.connect
      image = DPC.get_image image_item.path

      image_item.img_small = image
      image_item.save
    end
   
    begin
      CACHE.set(options.mc_img_s + params[:id], image)
    rescue Memcached::Error
      
    end
  end
  
  raise Sinatra::NotFound if image == nil

  image
end

get '/image/:id' do 
  content_type 'image/jpeg'
  
  begin
    image = CACHE.get(options.mc_img_l + params[:id])
  rescue Memcached::Error
    image_item = Photo.find(params[:id])
    image = DPC.get_image image_item.path, 'l'

    begin
      CACHE.set(options.mc_img_l + params[:id], image)
    rescue Memcached::Error
      
    end
  end
  
  raise Sinatra::NotFound if image == nil

  image
end