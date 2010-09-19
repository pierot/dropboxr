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

helpers do
  
end

get '/css/style.css' do
  content_type 'text/css', :charset => 'utf-8'
  less :'css/style'
end

get '/' do
  @albums = Album.all()
  
  erb :index
end

get '/gallery/:album' do
  begin
    album = Album.find(params[:album])
    
    @album_name = album.path
    @photos = album.photos.each

    erb :gallery
  rescue ActiveRecord::RecordNotFound
    redirect '/'
  end
end

get '/thumb/:id' do
  content_type 'image/jpeg'
  
  image_item = Photo.find(params[:id])
  image = image_item.thumb

  if image.nil? && DPC.connect
    puts "Thumnbail :: Was not present, is saved now"
    
    image = DPC.session.thumbnail image_item.path

    image_item.thumb = image
    image_item.save
  end

  image
end