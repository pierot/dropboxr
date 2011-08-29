class PhotosController < ApplicationController

  def show
    @album = Album.find_by_slug(params[:album_id])
    @photos = @album.photos
    @photo = Photo.find_by_id(params[:id])

    @photo_next, @photo_prev, @count = prev_next_photos(@album.photos, @photo.id)
  end

  private

    def prev_next_photos(photos, photo_id)
      photo_next = photos[0] if photos.length > 0
      photo_prev = photos[photos.length - 1] if photos.length > 0
      count = 0
      
      photos.each_with_index do |photo, index|
        if photo.id == photo_id
          photo_prev = photos[index - 1] unless photos[index - 1].nil?
          photo_next = photos[index + 1] unless photos[index + 1].nil?
          
          count = index + 1
          
          break
        end
      end
      
      return photo_next, photo_prev, count
    end

end
