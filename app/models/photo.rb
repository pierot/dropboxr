class Photo < ActiveRecord::Base
  belongs_to :album

  has_attached_file :photo, :styles => {:thumb => "128x85>"},
                            :storage => :s3,
                            :s3_credentials => "#{Rails.root}/config/s3.yml",
                            :s3_permissions => "public-read",
                            :s3_protocol => 'http'

  validates :name, :presence => true
  validates :path, :presence => true
  validates :revision, :presence => true
  validates :modified, :presence => true

  scope :not_cached, where('photo_file_name IS NULL')
  scope :cached, where('photo_file_name IS NOT NULL')

  def image_data(size = 'huge')
    cached = cache_it

    photo_path = if size == 'thumb'
      self.photo.url(:thumb)
    elsif size == 'original'
      image_data = Dropboxr::Connector.connection.get_image self.path, {:size => size}
    else
      self.photo.url
    end

    image_data ||= open(photo_path) { |f| f.read }
  end

  def cache_it
    return true unless self.photo.nil? || !self.photo.present? # thus, only first time

    image = Dropboxr::Connector.connection.get_image self.path, {:size => 'huge'}

    file_path = "#{Rails.root}/tmp/#{self.id}.jpg"

    file_content = File.open(file_path, "wb") do |f|
      f.write(image)
    end if image

    if File.exists?(file_path)
      self.photo = File.new(file_path)

      save!

      File.delete(file_path)
    end

    true
  end

end
