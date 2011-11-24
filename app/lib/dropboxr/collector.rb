module Dropboxr
  
  module Collector
    
    Gallery = Struct.new(:name, :path, :modified, :photos)
    Photo = Struct.new(:path, :name, :revision, :modified)
    
    def collect(dir_excludes = [])
      items = get_galleries
      galleries = []
      
      puts "Dropboxr::Connector::Collector Collect #{items.length} galleries."
      
      items.each do |item| 
        galleries << collect_gallery(item) if item.directory? && !(dir_excludes.include? item.path)
      end

      puts "Dropboxr::Connector::Collector Collected #{items.length} galleries."
      
      galleries
    end
  
    def collect_gallery(gallery)
      puts "Dropboxr::Connector::Collector CollectGallery #{gallery.path}"
      
      items = get_photos gallery.path
      items.sort!{ |a, b| a.path <=> b.path } # alphabetic

      photos = []
      
      items.each do |item|
        if !item.directory? && (defined? item.mime_type && item.mime_type == 'image/jpeg')
          photos << Photo.new(  item.path, 
                                item.path.scan(/([^\/]+)(?=\.\w+$)/)[0][0].to_s, 
                                item.revision, 
                                item.modified)
        end
      end

      Gallery.new(  gallery.path.split(/\//)[gallery.path.split(/\//).length - 1].to_s, 
                    gallery.path, 
                    gallery.modified.to_s, 
                    photos)
    end

    def build
      puts "Dropboxr::Connector::Collector Build"

      begin
        galleries = collect(['/Photos/iPod Photo Cache']) # exclude folders

        galleries.each do |gallery|
          album = Album.find_or_create_by_name gallery.name
          album.path = gallery.path
          album.save

          puts "Dropboxr::Connector::Builder Building :: #{album.modified} != #{gallery.modified}"

          if album.valid?
            if album.modified != gallery.modified.to_s
              puts "Dropboxr::Connector::Builder Creating or Updating #{album.name} modified on: #{gallery.modified.to_s} <> #{album.modified}"

              album.modified = gallery.modified
              album.save

              # puts "Album modified :: #{album.modified}"

              gallery_puts = ""
              gallery.photos.each do |item|
                photo = album.photos.find_or_create_by_path(item.path)

                if photo.name.nil? || photo.modified != item.modified # photo not in db or modification date is updated
                  if photo.name.nil? # new
                    photo.name = item.name
                    photo.path = item.path

                    gallery_puts << "Dropboxr::Connector::Builder Photo :: Creating #{photo.path} ...\n"
                  else
                    photo.updated = true

                    gallery_puts << "Dropboxr::Connector::Builder Photo :: Updating #{photo.path} ...\n"
                  end

                  photo.revision = item.revision
                  photo.modified = item.modified

                  photo.save
                end
              end

              puts gallery_puts

              album.save
              album.cache_photos

              puts "Dropboxr::Connector::Builder Gallery :: Saved #{album.name}"
            end
          else
            puts "Dropboxr::Connector::Builder Gallery :: Not saved"

            p album.errors
          end
        end
      rescue Exception => e
        p e

        false 
      end 

      true
    end

  end

end
