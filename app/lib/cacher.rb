class Cacher
  @queue :caching
 
  def non_cached
    Photo.where('photo_file_name IS NULL')
  end

  def self.perform
    to_run = non_cached

    to_run.each do |photo|
      photo.cache_it
    end
  end

end
