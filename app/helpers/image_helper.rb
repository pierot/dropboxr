module ImageHelper

  def album_photo(album_id)
    album = Album.find(album_id)
    photo = album.photos.first

    photo
  end

  def photo_path(photo, size = 'huge')
    p = photo

    if p.photo.present?
      if size == 'thumb'  
        p.photo.url(:thumb)
      else
        p.photo.url
      end
    else
      image_path photo.id, size
    end
  end

end
