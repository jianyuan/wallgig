class SetImageGravityDefaultToWallpapers < ActiveRecord::Migration
  def up
    change_column_default(:wallpapers, :image_gravity, 'c')
  end

  def down
    change_column_default(:wallpapers, :image_gravity, nil)
  end
end
