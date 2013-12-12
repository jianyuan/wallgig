class AddCachedTagListToWallpapers < ActiveRecord::Migration
  def change
    add_column :wallpapers, :cached_tag_list, :text
  end
end
