class ManageController < ApplicationController

  def index
    @count_photos = Photo.all.length
    @count_cached_photos = Photo.cached.length
    @count_not_cached_photos = Photo.not_cached.length
  end

end
