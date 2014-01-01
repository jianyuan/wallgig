class LockWallpaperPurityWorker
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  recurrence { hourly 1 }

  def perform
    Wallpaper.where('updated_at < ?', 30.minutes.ago)
             .with_purities('sketchy', 'nsfw')
             .update_all(purity_locked: true)
  end
end