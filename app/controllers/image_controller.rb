require 'open-uri'

class ImageController < ApplicationController
  def index
    photo = Photo.find(params[:id])

    send_data photo.image_data(params[:size] || 'huge'), :type => 'image/jpeg'
  end
end
