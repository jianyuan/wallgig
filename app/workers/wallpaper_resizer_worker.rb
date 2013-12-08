class WallpaperResizerWorker
  include Sidekiq::Worker
  include Timeout
  sidekiq_options queue: :wallpapers

  def perform(wallpaper_id)
    timeout(300) do
      @wallpaper = Wallpaper.find(wallpaper_id)
      generate_images
      @wallpaper.save!
    end
  end

  def generate_images
    generate_standard_image
    generate_image(:standard_image, :large_image, '1500x', '-quality 80')
    # generate_image(:standard_image, :thumbnail_image, '500x500>', '-quality 70')
    generate_image(:standard_image, :thumbnail_image, '250x188#', '-quality 70')
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

  def generate_standard_image
    @wallpaper.standard_image = @wallpaper.image.thumb('3000x3000>')
  end
end