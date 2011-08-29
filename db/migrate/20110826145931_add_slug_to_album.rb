class AddSlugToAlbum < ActiveRecord::Migration
  def change
    add_column :albums, :slug, :string, :unique => true
  end
end
