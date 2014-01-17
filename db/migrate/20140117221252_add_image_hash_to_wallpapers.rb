class AddImageHashToWallpapers < ActiveRecord::Migration
  def change
    add_column :wallpapers, :image_hash, :string
    add_index :wallpapers, :image_hash
  end
end
