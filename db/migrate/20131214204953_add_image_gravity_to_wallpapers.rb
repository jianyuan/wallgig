class AddImageGravityToWallpapers < ActiveRecord::Migration
  def change
    add_column :wallpapers, :image_gravity, :string
  end
end
