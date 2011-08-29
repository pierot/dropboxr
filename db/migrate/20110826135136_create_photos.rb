class CreatePhotos < ActiveRecord::Migration
  def change
    create_table :photos do |t|
      t.integer :album_id
      t.string :name
      t.string :path
      t.string :revision
      t.string :modified
      t.boolean :updated

      t.timestamps
    end
  end
end
