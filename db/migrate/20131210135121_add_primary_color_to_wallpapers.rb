class AddPrimaryColorToWallpapers < ActiveRecord::Migration
  def change
    add_reference :wallpapers, :primary_color, index: true
  end
end
