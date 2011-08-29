class Photo < ActiveRecord::Base
  # extend FriendlyId
  # friendly_id :name, :use => :scoped, :scope => :album_id

  belongs_to :album
end
