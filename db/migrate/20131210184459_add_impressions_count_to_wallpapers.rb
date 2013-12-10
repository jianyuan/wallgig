class AddImpressionsCountToWallpapers < ActiveRecord::Migration
  def change
    add_column :wallpapers, :impressions_count, :integer, default: 0
  end
end
