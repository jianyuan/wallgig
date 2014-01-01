class WallpaperAttributeUpdateWorker
  include Sidekiq::Worker
  sidekiq_options queue: :wallpapers

  def perform(wallpaper_id, method)
    Thread.new do
      ActiveRecord::Base.connection_pool.with_connection do |conn|
        Wallpaper.find(wallpaper_id).send(method.to_s)
      end
    end
  end

end