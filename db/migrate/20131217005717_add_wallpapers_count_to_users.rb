class AddWallpapersCountToUsers < ActiveRecord::Migration
  def change
    add_column :users, :wallpapers_count, :integer, default: 0
  end
end
