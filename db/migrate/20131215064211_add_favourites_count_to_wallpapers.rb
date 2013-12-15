class AddFavouritesCountToWallpapers < ActiveRecord::Migration
  def change
    add_column :wallpapers, :favourites_count, :integer, default: 0
  end
end
