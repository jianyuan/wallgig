class WallpaperColorExtractorWorker
  include Sidekiq::Worker
  include Timeout
  sidekiq_options queue: :wallpapers

  def perform(wallpaper_id)
    timeout(60) do
      Wallpaper.find(wallpaper_id).extract_colors
    end
  end

end