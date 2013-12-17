class WallpaperResizerWorker
  include Sidekiq::Worker
  include Timeout
  sidekiq_options queue: :wallpapers

  def perform(wallpaper_id)
    timeout(60) do
      @wallpaper = Wallpaper.find(wallpaper_id)
      generate_images
      @wallpaper.save!
    end
  end

  def generate_images
    generate_image(:image, :thumbnail_image, "250x188\##{@wallpaper.image_gravity}", '-quality 70')
  end

  def generate_image(source, target, size, encode_opts)
    source = @wallpaper.send(source)
    if source.present?
      image = source.thumb(size).encode(:jpg, encode_opts)
      @wallpaper.send("#{target}=", image)
    else
      raise "Source doesn't exist yet"
    end
  end
end