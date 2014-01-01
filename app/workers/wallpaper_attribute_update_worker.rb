class WallpaperAttributeUpdateWorker
  include Sidekiq::Worker
  sidekiq_options queue: :wallpapers

  def perform(wallpaper_id, method)
    Wallpaper.find(wallpaper_id).send(method.to_s)
  end

end