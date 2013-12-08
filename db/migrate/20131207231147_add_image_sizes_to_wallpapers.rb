class AddImageSizesToWallpapers < ActiveRecord::Migration
  def change
    add_column :wallpapers, :standard_image_uid, :string
    add_column :wallpapers, :large_image_uid, :string
    add_column :wallpapers, :thumbnail_image_uid, :string
  end
end
