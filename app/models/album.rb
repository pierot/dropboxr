class Album < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, :use => :slugged

  scope :ordered, order('albums.name ASC')

  has_many :photos

  validates :name, :presence => true
  validates :path, :presence => true

  def is_new?
    unless modified.nil?
      Date.parse(modified).to_datetime.in_time_zone('UTC') > 1.month.ago
    else
      false
    end
  end

  def cache_photos
    Resque.enqueue(Cacher, self.id)
  end
end
