class WallpaperMerger
  def initialize(from_wallpaper, to_wallpaper)
    @from_wallpaper = from_wallpaper
    @to_wallpaper = to_wallpaper
  end

  def execute
    @to_wallpaper.tag_list += @from_wallpaper.tag_list
    @to_wallpaper.source ||= @from_wallpaper.source

    transfer_favourites
    transfer_impressions

    @from_wallpaper.destroy

    @to_wallpaper.save
    @to_wallpaper
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