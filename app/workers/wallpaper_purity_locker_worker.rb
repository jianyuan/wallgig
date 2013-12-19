class WallpaperPurityLockerWorker
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  recurrence { hourly 2 }

  def perform
    Wallpaper.where('updated_at < ?', 1.hour.ago)
             .where(purity: [:sketchy, :nsfw])
             .update_all(purity_locked: true)
  end
end