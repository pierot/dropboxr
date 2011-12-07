class Manage::QeueController < ApplicationController
  before_filter :check_installation

  def cache
    albums = Album.select("albums.id").ordered
    albums.each do |album|
      album.cache_photos
    end
  end

  def build
    albums = Album.select("albums.path").all

    albums.each do |album|
      album.build_photos
    end
  end

  private

    def check_installation
      redirect_to root_path if Installation.installed.empty?
    end

end
