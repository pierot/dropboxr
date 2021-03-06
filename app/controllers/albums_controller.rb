class AlbumsController < ApplicationController

  def index
    return redirect_to manage_install_index_path if Installation.installed.empty?

    @albums = Album.ordered.all

    redirect_to manage_index_path if @albums.empty?
  end

  def show
    @album = Album.includes(:photos).find_by_slug(params[:id])
    @photos = @album.photos
  end

end
