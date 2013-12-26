class AddPhashToWallpapers < ActiveRecord::Migration
  def change
    add_column :wallpapers, :phash, :bigint, index: true
    add_index :wallpapers, :phash
  end
end
