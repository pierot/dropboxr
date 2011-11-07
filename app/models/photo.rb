class Photo < ActiveRecord::Base
  belongs_to :album

  validates :name, :presence => true
  validates :path, :presence => true
  validates :revision, :presence => true
  validates :modified, :presence => true
end
