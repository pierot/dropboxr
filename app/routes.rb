#########################################################################################################
# VARIOUS
#########################################################################################################
before do
  #headers['Cache-Control'] = 'public, max-age=172800' # Two days
  
  if :agent.to_s =~ /(Slurp|msnbot|Googlebot)/ # bots not allowed
    redirect 'http://noort.be'
  end
end

before '/build/*' do
  protected!
end

error do
  'Sorry there was a nasty error - ' + request.env['sinatra.error'].name
end

not_found do
  'Sorry - Not Found'
end

get '/timecheck' do
  session[:time] = Time.new if session[:time].nil?
  
  "Current Time : " + session[:time].inspect
end

get '/manifest' do
  headers 'Content-Type' => 'text/cache-manifest' # Must be served with this MIME type
  
  files = []
  albums = albums_excluding
  
  albums.each do |album|
    album.photos.each { |photo| files << "/image/#{photo.id}/medium" }
  end
  
  files << request.referer
  
  Manifesto.cache :files => files
end

#########################################################################################################
# BUILDING / SETUP
#########################################################################################################
['/build/building/?', '/build/building/*'].each do |path|
  get path do
    redirect '/build/error' unless settings.dpc.authorized?
    
    all_fine, message = build_galleries
    
    if all_fine
      redirect '/build/done'
    else
      p message
      
      redirect '/build/error'
    end
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
  when 'reset'
    @redirect_url = '/build/start'
    
    DatabaseCleaner.clean
    
    redirect @redirect_url
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
  @albums = albums_excluding
  
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

get %r{/gallery/([\w]+)/(image|slide)/([\w]+)} do
  param_album = params[:captures][0]
  param_type  = params[:captures][1]
  param_photo = params[:captures][2]
  
  begin
    @album = Album.find(param_album)
  rescue ActiveRecord::RecordNotFound
    redirect '/' # back
  end
  
  @photos = @album.photos 
  @photo, @photo_next, @photo_prev = prev_next_photos(@photos, param_photo.to_i)
    
  redirect '/' if @photos.length == 0 || @photo.nil?
  
  erb :"#{param_type}"
end

#########################################################################################################
# IMAGES
#########################################################################################################
get '/image/:id/:size' do 
  content_type 'image/jpeg'
  
  id = params[:id]
  size = params[:size] || 'small'
  image_file_path = "#{settings.cache_data}/#{size}_#{id}.jpg"
  file_exists = false
  
  if file_exists = File.exists?(image_file_path)
    image = File.open(image_file_path, 'rb') { |file| file.read }
  end
  
  if image.nil?
    begin
      image_item = Photo.find(id)
      image = settings.dpc.get_image image_item.path, {:size => size}
    rescue ActiveRecord::RecordNotFound
      # silent
    end
  end
  
  if !image.nil? && !file_exists
    puts "Save image to disk :: #{image_file_path}"
      
    File.open(image_file_path, "wb") do |f|
      f.write(image)
    end
  end
 
  raise Sinatra::NotFound if image == nil

  image
end