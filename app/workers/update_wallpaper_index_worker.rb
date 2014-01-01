class UpdateWallpaperIndexWorker
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  recurrence { hourly 2 }

  def perform
    Thread.new do
      ActiveRecord::Base.connection_pool.with_connection do |conn|
        Wallpaper.visible.find_each &:update_index
      end
    end
  end
end