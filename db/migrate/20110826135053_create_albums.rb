class CreateAlbums < ActiveRecord::Migration
  def change
    create_table :albums do |t|
      t.string :name
      t.string :path
      t.string :modified

      t.timestamps
    end
  end
end
