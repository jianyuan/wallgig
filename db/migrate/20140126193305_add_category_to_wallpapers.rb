class AddCategoryToWallpapers < ActiveRecord::Migration
  def change
    add_reference :wallpapers, :category, index: true
  end
end
