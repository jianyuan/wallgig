class WallpaperAttributeUpdateWorker
  include Sidekiq::Worker
  include Timeout
  sidekiq_options queue: :wallpapers

  def perform(wallpaper_id, method)
    timeout(60) do
      Wallpaper.find(wallpaper_id).send(method.to_s)
    end
  end

end