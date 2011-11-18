require 'open-uri'

class ImageController < ApplicationController
  def index
    photo = Photo.find(params[:id]) 
    size = params[:size] || 'medium'

    if photo.photo.nil? || !photo.photo.present? # thus, only first time
      image = dropboxr_conn.get_image photo.path, {:size => 'huge'}

      file_path = "#{Rails.root}/tmp/#{photo.id}.jpg"
      file_content = File.open(file_path, "wb") do |f| 
        f.write(image)
      end if image

      photo.photo = File.new(file_path)
      photo.save!

      File.delete(file_path)
    end

    photo_path = if size == 'thumb'
      photo.thumb
    elsif size == 'original'
      image_data = dropboxr_conn.get_image photo.path, {:size => size} 
    else
      photo.image
    end

    image_data ||= open(photo_path) { |f| f.read }

    send_data image_data, :type => 'image/jpeg'
  end
end
