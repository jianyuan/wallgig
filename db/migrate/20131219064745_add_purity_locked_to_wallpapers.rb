class AddPurityLockedToWallpapers < ActiveRecord::Migration
  def change
    add_column :wallpapers, :purity_locked, :boolean, default: false
  end
end
