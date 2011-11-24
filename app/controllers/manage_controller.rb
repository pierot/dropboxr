class ManageController < ApplicationController

  def index
  end

  def cache
    albums = Album.select("id").all
    albums.each do |album|
      Resque.enqueue(Cacher, album.id)
    end
  end

end
