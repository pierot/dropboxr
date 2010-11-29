module DropboxrHelpers
  def build_galleries
    begin
      galleries = DPC.collect

      galleries.each do |gallery|
        album = Album.find_or_create_by_name gallery.name

        puts "DropboxrHelpers :: BuildGalleries :: Building :: #{album.modified} != #{gallery.modified}"

        if album.modified != gallery.modified.to_s
          puts "Gallery :: Creating or Updating #{album.name} modified on: #{gallery.modified.to_s} <> #{album.modified}"

          gallery.photos.each do |item|
            photo = album.photos.find_or_create_by_path(item.path)

            if photo.name.nil? || photo.modified != item.modified
              if photo.name.nil? # new
                photo.name = item.name
                photo.path = item.path

                puts "DropboxrHelpers :: BuildGalleries :: Photo :: Creating #{photo.path} ..."
              else
                puts "DropboxrHelpers :: BuildGalleries :: Photo :: Updating #{photo.path} ..."
              end

              photo.revision = item.revision
              photo.modified = item.modified

              photo.save
              album.save
            end
          end
          
          album.path = gallery.path
          album.modified = gallery.modified
          album.save
        end
      end
    rescue Exception => e
      return false, e
    end
    
    return true, 'All done!'
  end
end