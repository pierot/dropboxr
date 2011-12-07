class CacherQeue < Resque::JobWithStatus
  @queue = :caching

  def perform
    to_run = Album.find_by_id(options['album_id']).photos.not_cached
    total = to_run.size

    to_run.each_with_index do |photo, index|
      at(index, total, "At #{index} of #{total} photos for album #{options['album_id']}")

      photo.cache_it
    end

    completed
  end

end
