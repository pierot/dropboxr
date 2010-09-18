require 'active_record'
require 'yaml'

#ActiveRecord::Base.establish_connection(YAML::load(File.open('config/database.yml')))

ActiveRecord::Base.establish_connection(
  :adapter  => "sqlite3",
  :database => "photos.db"
)

begin
  puts "Database :: Creating schema."
  
  ActiveRecord::Schema.define do
    create_table :albums do |table|
      table.column :path, :string
      table.column :modified, :string
    end
  
    create_table :photos do |table|
      table.column :album_id, :integer
      table.column :name, :string
      table.column :path, :string
      table.column :link, :string
      table.column :thumb, :binary
      table.column :revision, :string
      table.column :modified, :string
    end
  end
rescue ActiveRecord::StatementInvalid
  # schema already exists
  puts "Database :: Schema already existed."
end

class Album < ActiveRecord::Base
  has_many :photos
end

class Photo < ActiveRecord::Base
  belongs_to :albums
end