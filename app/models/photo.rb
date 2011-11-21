class Photo < ActiveRecord::Base
  belongs_to :album

  has_attached_file :photo, :styles => {:thumb => "128x85>"}, 
                            :storage => :s3,
                            :s3_credentials => "#{Rails.root}/config/s3.yml",
                            :s3_permissions => "public-read", 
                            :s3_protocol => 'http'
                            # :url  => ":s3_eu_url"

  validates :name, :presence => true
  validates :path, :presence => true
  validates :revision, :presence => true
  validates :modified, :presence => true

end
