class BuilderQeue
  @queue = :building

  def self.perform(album_path)
    Dropboxr::Connector.connection.build_gallery album_path
  end

end
