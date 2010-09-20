before do
  puts "before do"
  if DPC.connect
    galleries = DPC.get_galleries # directory where you save your photos can be argument, 'Photos' is default

    galleries.each do |gallery|
      load_gallery gallery if gallery.directory?
    end
  end
end

def load_gallery(gallery)
  album = Album.find_or_create_by_path(gallery.path)
  
  if album.modified != album.modified
    puts "Gallery :: Creating #{gallery.path} modified on: #{gallery.modified}" # -> (#{gallery.inspect})"
    
    album.modified = gallery.modified
  
    photos = DPC.get_photos gallery.path
    
    photos.each do |item|
      if defined? item.mime_type && item.mime_type == "image/jpeg"
        unless photo = album.photos.find_by_path(item.path)
          load_photo(album, item)
        end
      end
    
      album.save
    end
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
  
  begin
    @albums = CACHE.get('albums')
  rescue Memcached::Error
    @albums = Album.all()
    
    CACHE.set('albums', @albums)
  end
  
  erb :index
end

get '/gallery/:album' do
  headers['Cache-Control'] = 'public, max-age=172800' # Two days
  
  begin
    album = CACHE.get('album_' + params[:album])
  rescue Memcached::Error
    begin
      album = Album.find(params[:album])
      
      CACHE.set('album_' + params[:album], album)
    rescue ActiveRecord::RecordNotFound
      redirect '/'
    end
  end
  
  @album_name = album.path
  @photos = album.photos.each

  erb :gallery
end

get '/thumb/:id' do 
  headers['Cache-Control'] = 'public, max-age=172800' # Two days
  
  content_type 'image/jpeg'
  
  begin
    image = CACHE.get('thumb_' + params[:id])
  rescue Memcached::Error
    image_item = Photo.find(params[:id])
    image = image_item.thumb

    if image.nil? && DPC.connect
      puts "Thumnbail :: Was not present, is saved now"

      image = DPC.get_thumbnail image_item.path, 'l'

      image_item.thumb = image
      image_item.save
    end
    
    CACHE.set('thumb_' + params[:id], image)

    raise Sinatra::NotFound if image == nil
  end

  image
end