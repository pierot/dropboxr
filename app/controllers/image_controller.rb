class ImageController < ApplicationController
  def index
    photo = Photo.find(params[:id]) 
    size = params[:size] || 'medium'

    dbr_conn = dropboxr_conn

    image = dbr_conn.get_image photo.path, {:size => size}

    send_data image, :type => 'image/jpeg'
  end
end
