class UpdateWallpaperIndexWorker
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  recurrence { hourly 2 }

  def perform
    Wallpaper.visible.find_each &:update_index
  end
end