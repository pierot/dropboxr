class Album < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, :use => :slugged

  has_many :photos

  validates :name, :presence => true
  validates :path, :presence => true
end
