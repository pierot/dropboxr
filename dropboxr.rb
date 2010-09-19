##!/usr/bin/ruby

require 'rubygems'
require 'sinatra'

require './dropbox_connector.rb'
require './dropbox_database.rb'

@dpc = DropboxConnector.new(  'http://www.wellconsidered.be/', 
                              'config/dropbox-key.txt', 
                              'ysr84fd8hy49v9k', 
                              'oxye3gyi03lqmd4')

def load_gallery(gallery)
  puts "Gallery :: #{gallery.path} modified on: #{gallery.modified}" # -> (#{gallery.inspect})"
  
  photos = @dpc.session.list gallery.path #, {suppress_list: true}
  photos_dir = "./thumbs/" + gallery.path
  
  album = Album.find_or_create_by_path(gallery.path)
  album.modified = gallery.modified
  album.save
  
  # Heroku is read-only.
  #FileUtils.mkdir_p photos_dir unless File.directory? photos_dir
  
  photos.each do |item|
    if defined? item.mime_type && item.mime_type == "image/jpeg"
      unless photo = album.photos.find_by_path(item.path)
        path = @dpc.session.link item.path
        path.sub!(/\/dropbox/, "") # remove dropbox from path for direct linking
        
        photo = album.photos.create(  :name => "#{photos_dir}/#{path.scan(/\w+\.\w+$/)[0]}",
                                      :path => "/#{item.path}",
                                      :link => path, 
                                      #:thumb => @dpc.session.thumbnail(item.path), # We do this later on
                                      :revision => item.revision, 
                                      :modified => item.modified)
                                          
        puts "Photo :: Creating #{photo.path} ..."
      end

      # Heroku is read-only. Saving thumnbail in database is enough.
      #unless File.exist? photo.name
      #  puts "Photo :: Saving photo: #{photo.path} modified on: #{photo.modified}"
      #
      #  a = File.new(photo.name, "wb")
      #  a.write(photo.thumb)
      #  a.close
      #end
    end
    
    album.save
  end
end

if @dpc.connect
  galleries = @dpc.session.list 'Photos'

  galleries.each do |gallery|
    load_gallery gallery if gallery.directory?
  end
end

configure do
  # do stuff
end

before do
  # do stuff before each request
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
  
  if image.nil? && @dpc.connect
    image = @dpc.session.thumbnail image_item.path
  end

  image
end