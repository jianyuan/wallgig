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

      merge_comments
      merge_favourites
      merge_impressions

      @from_wallpaper.destroy

      @to_wallpaper.save
    end
  end

  private
    def merge_comments
      Comment.where(commentable: @from_wallpaper).update_all(commentable_id: @to_wallpaper.id)
    end

    def merge_favourites
      user_ids = @from_wallpaper.favourites.pluck(:user_id)
      Favourite.where(user_id: user_ids, wallpaper_id: @to_wallpaper.id).delete_all

      Favourite.where(wallpaper_id: @from_wallpaper.id).update_all(wallpaper_id: @to_wallpaper.id)
    end

    def merge_impressions
      Impression.where(impressionable: @from_wallpaper).update_all(impressionable_id: @to_wallpaper.id)
    end
end