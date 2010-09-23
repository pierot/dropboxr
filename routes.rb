before do
  headers['Cache-Control'] = 'public, max-age=172800' # Two days
  
  #if !DPC.connect && request.path_info != '/setup' # try to connect
  #  redirect '/setup'
  #end
end

error do
  'Sorry there was a nasty error - ' + request.env['sinatra.error'].name
end

not_found do
  'Sorry - Not Found'
end

get '/setup' do
  
end

['/rebuild/?', '/rebuild/*'].each do |path|
  get path do
    if DPC.connect
      galleries = DPC.get_galleries # directory where you save your photos can be argument, 'Photos' is default

      begin
        Timeout::timeout(20) do
          galleries.each do |gallery| 
            load_gallery gallery if gallery.directory? && !(options.album_excludes.include? gallery.path)
          end
        end
      rescue Timeout::Error
        redirect "/rebuild/#{rand(99999999)}"
      end
    end
    
    redirect '/' 
  end
end

get '/css/style.css' do
  content_type 'text/css', :charset => 'utf-8'
  
  less :'css/style'
end

get '/' do
  begin
    @albums = CACHE.get(options.mc_albums)
  rescue Memcached::Error
    @albums = Album.all() # Should make sure the 'not in' is in the query or so .... :conditions => {:path => })
  
    CACHE.set(options.mc_albums, @albums)
  end

  @albums.each { |alb| @albums.delete(alb) if options.album_excludes.include? alb.path }
  
  erb :index
end

get '/gallery/:album' do
  begin
    @album = CACHE.get(options.mc_album + params[:album])
  rescue Memcached::Error
    begin
      @album = Album.find(params[:album])
      
      CACHE.set(options.mc_album + params[:album], @album)
    rescue ActiveRecord::RecordNotFound
      redirect '/'
    end
  end
  
  @photos = @album.photos.each

  erb :gallery
end

get '/gallery/:album/image/:id' do 
    begin
      @album = Album.find(params[:album])
      @photo = @album.photos.find(params[:id])
      
    rescue ActiveRecord::RecordNotFound
      redirect back
    end

    erb :image
end

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
    
     CACHE.set(options.mc_img_s + params[:id], image)
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

    CACHE.set(options.mc_img_l + params[:id], image)
  end
  
  raise Sinatra::NotFound if image == nil

  image
end