class WallpaperMerger
  def self.from(from_wallpaper)
    new(from_wallpaper)
  end

  def initialize(from_wallpaper)
    @from_wallpaper = from_wallpaper
  end

  def to(to_wallpaper)
    @to_wallpaper = to_wallpaper
    self
  end

  def execute
    Wallpaper.transaction do
      @to_wallpaper.tag_list += @from_wallpaper.tag_list
      @to_wallpaper.source ||= @from_wallpaper.source

      transfer_favourites
      transfer_impressions

      @from_wallpaper.destroy

      @to_wallpaper.save
    end
  end

  private
    def transfer_favourites
      @from_wallpaper.favourites.each do |favourite|
        if Favourite.where(wallpaper: @to_wallpaper, user: favourite.user).exists?
          favourite.destroy
        else
          favourite.wallpaper = @to_wallpaper
          favourite.save
        end
      end
    end

    def transfer_impressions
      @from_wallpaper.impressions.each do |impression|
        impression.impressionable = @to_wallpaper
        impression.save
      end
    end
end