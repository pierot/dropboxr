class RemoveSecretAndKeyFromInstallation < ActiveRecord::Migration
  def up
    remove_column :installations, :secret
    remove_column :installations, :key
  end

  def down
  end
end
