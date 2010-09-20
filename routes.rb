before do
  if DPC.connect
    galleries = DPC.session.list 'Photos'

    galleries.each do |gallery|
      load_gallery gallery if gallery.directory?
    end
  end
end

error do
  'Sorry there was a nasty error - ' + request.env['sinatra.error'].name
end

not_found do
  'Sorry - Not Found'
end

helpers do
  
end

get '/css/style.css' do
  content_type 'text/css', :charset => 'utf-8'
  less :'css/style'
end

get '/' do
  headers['Cache-Control'] = 'public, max-age=172800' # Two days
  
  @albums = Album.all()
  
  erb :index
end

get '/gallery/:album' do
  headers['Cache-Control'] = 'public, max-age=172800' # Two days
  
  begin
    album = Album.find(params[:album])
    
    @album_name = album.path
    @photos = album.photos.each

    erb :gallery
  rescue ActiveRecord::RecordNotFound
    redirect '/'
  end
end

get '/thumb/:id'
  headers['Cache-Control'] = 'public, max-age=172800' # Two days
  
  content_type 'image/jpeg'
  
  #begin
    image_cached = CACHE.get('thumb_' + params[:id])
    return image_cached if image_cached
  #rescue Memcached::Error
    image_item = Photo.find(params[:id])
    image = image_item.thumb

    if image.nil? && DPC.connect
      puts "Thumnbail :: Was not present, is saved now"

      image = DPC.session.thumbnail image_item.path

      image_item.thumb = image
      image_item.save
    end
    
    CACHE.set('thumb_' + params[:id], image)

    raise Sinatra::NotFound if image == nil
  #end

  image
end