class Photo < ActiveRecord::Base
  belongs_to :album

  has_attached_file :photo, :styles => {:thumb => "128x85>"}

  validates :name, :presence => true
  validates :path, :presence => true
  validates :revision, :presence => true
  validates :modified, :presence => true
end
