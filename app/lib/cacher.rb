class Cacher
  @queue = :caching

  def self.perform
    to_run = Photo.where('photo_file_name IS NULL')

    to_run.each do |photo|
      photo.cache_it
    end
  end

end
