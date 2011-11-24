class ManageController < ApplicationController

  def index
  end

  def cache
    albums = Album.select("id").all
    albums.each do |album|
      album.cache_photos
    end
  end

end
