##!/usr/bin/ruby

require 'rubygems'
require 'sinatra'

require './dropbox_connector.rb'
require './dropbox_database.rb'

get '/' do
  "Hello World!"
end

get '/gallery/:album' do
  album = Album.find_by_name(params[:album])
  
  puts album.length
end

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
  
  FileUtils.mkdir_p photos_dir unless File.directory? photos_dir
  
  photos.each do |item|
    if defined? item.mime_type && item.mime_type == "image/jpeg"
      unless photo = album.photos.find_by_path(item.path)
        path = @dpc.session.link item.path
        path.sub!(/\/dropbox/, "") # remove dropbox from path for direct linking
        
        photo = album.photos.create(  :name => "#{photos_dir}/#{path.scan(/\w+\.\w+$/)[0]}",
                                      :path => "/#{item.path}",
                                      :link => path, 
                                      :thumb => @dpc.session.thumbnail(item.path), 
                                      :revision => item.revision, 
                                      :modified => item.modified)
                                          
        puts "Photo :: Creating #{photo.path} ..."
      end

      # Heroku is read-only. Saving thumnbail in database is enough.
      #
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
  
  puts "Done"
end