module Dropboxr

  module Collector

    Gallery = Struct.new(:name, :path, :modified, :photos)
    Photo = Struct.new(:path, :name, :revision, :modified)

    # Gather all galleries
    # And save in DB
    def collect_galleries(dir_excludes = ['/Photos/iPod Photo Cache'])
      items = get_galleries
      galleries = []

      items.each do |item| 
        name = item["path"].split(/\//)[item["path"].split(/\//).length - 1].to_s
        album = Album.find_or_create_by_name(name) if item["is_dir"] && !(dir_excludes.include? item["path"])

        unless album.nil?
          album.path = item["path"]
          album.save
        end
      end
    end

    # Collect all photos of all galleries
    # And save in DB
    def build_galleries
      collect_galleries

      albums = Album.all

      albums.each do |album|
        build_gallery album.path
      end
    end

    # Collect all photos of gallery
    def collect_photos(gallery_path)
      items = get_photos gallery_path
      items.sort!{ |a, b| a["path"] <=> b["path"] } # alphabetic

      photos = []

      items.each do |item|
        if !item["is_dir"] && (defined? item["mime_type"] && item["mime_type"] == 'image/jpeg')
          photos << Photo.new(item["path"], item["path"].scan(/([^\/]+)(?=\.\w+$)/)[0][0].to_s, item["revision"], item["modified"])
        end
      end

      photos
    end

    # Collect all photos of gallery
    # And save in DB
    def build_gallery(gallery_path, &block)
      gallery = get_gallery gallery_path

      photos = collect_photos gallery_path
      photos_size = photos.size

      album = Album.find_by_path(gallery_path)

      if album.modified != gallery["modified"]
        puts "Dropboxr::Collector::BuildGallery Creating or Updating #{album.name} modified on: #{gallery["modified"]} <> #{album.modified}"

        album.modified = gallery["modified"]
        album.save

        photos.each_with_index do |item, index|
          photo = album.photos.find_or_create_by_path(item["path"])

          if photo.name.nil? || photo.modified != item["modified"] # photo not in db or modification date is updated
            if photo.name.nil? # new
              photo.name = item["name"]
              photo.path = item["path"]

              puts "Dropboxr::Collector::BuildGallery Photo :: Creating #{photo.path} ...\n"
            else
              photo.updated = true

              puts "Dropboxr::Collector::BuildGallery Photo :: Updating #{photo.path} ...\n"
            end

            photo.revision = item["revision"]
            photo.modified = item["modified"]

            photo.save

            yield index, photos_size, album.name if block_given?
          end
        end

        album.save
      end
    end

  end

end
