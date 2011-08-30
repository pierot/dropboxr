class AlbumsController < ApplicationController

  def index
    return redirect_to install_path if Installation.installed.empty?

    @albums = Album.all

    redirect_to build_path if @albums.empty?
  end

  def show
    @album = Album.includes(:photos).find_by_slug(params[:id])
    @photos = @album.photos
  end

end