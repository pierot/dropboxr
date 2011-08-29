class CreateInstallations < ActiveRecord::Migration
  def change
    create_table :installations do |t|
      t.text :session_key
      t.string :secret
      t.string :key

      t.timestamps
    end
  end
end
