class BuilderQeue < Resque::JobWithStatus
  @queue = :building

  def perform
    Dropboxr::Connector.connection.build_gallery options['album_path'] do |index, total, name|
      at("At #{index} of #{total} photos for album #{name}")
    end

    completed
  end

end
