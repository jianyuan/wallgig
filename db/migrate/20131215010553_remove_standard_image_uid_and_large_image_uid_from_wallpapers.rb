class RemoveStandardImageUidAndLargeImageUidFromWallpapers < ActiveRecord::Migration
  def change
    remove_column :wallpapers, :standard_image_uid, :string
    remove_column :wallpapers, :large_image_uid, :string
  end
end
