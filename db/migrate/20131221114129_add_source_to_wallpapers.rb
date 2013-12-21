class AddSourceToWallpapers < ActiveRecord::Migration
  def change
    add_column :wallpapers, :source, :string
  end
end
