before do
  if DPC.connect
    galleries = DPC.session.list 'Photos'

    galleries.each do |gallery|
      load_gallery gallery if gallery.directory?
    end
  end
end

get '/' do
  @albums = Album.find(:all)
  
  erb :index
end

get '/gallery/:album' do
  album = Album.find(params[:album])
  
  @photos = album.photos.each
  
  erb :gallery
end

get '/thumb/:id' do
  p @dpc
  content_type 'image/jpeg'
  
  image_item = Photo.find(params[:id])
  image = image_item.thumb
  
  if image.nil? && DPC.connect
    image = DPC.session.thumbnail image_item.path
  end

  image
end