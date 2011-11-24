class Cacher
  @queue = :caching

  def self.perform(album_id)
    to_run = Album.find_by_id(album_id).photos.not_cached

    to_run.each do |photo|
      photo.cache_it
    end
  end

end
