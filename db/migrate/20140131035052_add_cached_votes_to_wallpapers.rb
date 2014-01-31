class AddCachedVotesToWallpapers < ActiveRecord::Migration
  def self.up
    add_column :wallpapers, :cached_votes_total, :integer, :default => 0
    add_column :wallpapers, :cached_votes_score, :integer, :default => 0
    add_column :wallpapers, :cached_votes_up, :integer, :default => 0
    add_column :wallpapers, :cached_votes_down, :integer, :default => 0
    add_column :wallpapers, :cached_weighted_score, :integer, :default => 0
    add_index  :wallpapers, :cached_votes_total
    add_index  :wallpapers, :cached_votes_score
    add_index  :wallpapers, :cached_votes_up
    add_index  :wallpapers, :cached_votes_down
    add_index  :wallpapers, :cached_weighted_score

    # Uncomment this line to force caching of existing votes
    Wallpaper.find_each(&:update_cached_votes)
  end

  def self.down
    remove_column :wallpapers, :cached_votes_total
    remove_column :wallpapers, :cached_votes_score
    remove_column :wallpapers, :cached_votes_up
    remove_column :wallpapers, :cached_votes_down
    remove_column  :wallpapers, :cached_weighted_score
  end
end
