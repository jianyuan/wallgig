class CreateWallpaperColors < ActiveRecord::Migration
  def change
    create_table :wallpaper_colors do |t|
      t.references :wallpaper, index: true
      t.references :color, index: true
      t.float :percentage
    end
  end
end
