module ImageHelper

  def album_photo(album_id)
    album = Album.find(album_id)
    photo = album.photos.first

    photo.id
  end

end
