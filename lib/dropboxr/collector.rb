module Dropboxr
  
  module Collector
    
    Gallery = Struct.new(:name, :path, :modified, :photos)
    Photo = Struct.new(:path, :name, :revision, :modified)
    
    def collect(dir_excludes = [])
      dir_excludes = directory_excludes if dir_excludes.empty?
      items = get_galleries
      galleries = []
      
      puts "Dropboxr::Connector::Collector.Collect #{items.length} galleries."
      
      items.each do |item| 
        if item.directory? && !(dir_excludes.include? item.path)
          galleries << collect_gallery(item)
        end
      end
      
      galleries
    end
  
    def collect_gallery(gallery)
      puts "Dropboxr::Connector::Collector.CollectGallery #{gallery.path}"
      
      items = get_photos gallery.path
      items.sort!{ |a, b| a.path <=> b.path }

      photos = []
      
      items.each do |item| 
        if defined? item.mime_type && item.mime_type == "image/jpeg"
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

  end
  
end