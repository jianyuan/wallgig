class AddScrapeSourceAndScrapeIdToWallpapers < ActiveRecord::Migration
  def change
    add_column :wallpapers, :scrape_source, :string
    add_column :wallpapers, :scrape_id, :string
    add_index :wallpapers, [:scrape_source, :scrape_id], unique: true
  end
end
