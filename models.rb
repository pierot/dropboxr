require 'active_record'
require 'yaml'

dbconfig = YAML.load(File.read('config/database.yml'))

ActiveRecord::Base.establish_connection dbconfig[ENV['RACK_ENV']]

begin
  puts "Database :: Creating schema."
  
  ActiveRecord::Schema.define do
    create_table :albums do |table|
      table.column :name, :string
      table.column :path, :string
      table.column :modified, :string
    end
  
    create_table :photos do |table|
      table.column :album_id, :integer
      table.column :name, :string
      table.column :path, :string
      table.column :link, :string
      table.column :img_small, :binary
      table.column :img_large, :binary
      table.column :revision, :string
      table.column :modified, :string
    end
  end
rescue ActiveRecord::StatementInvalid
  puts "Database :: Schema already existed."
end

class Album < ActiveRecord::Base
  has_many :photos
end

class Photo < ActiveRecord::Base
  belongs_to :albums
end