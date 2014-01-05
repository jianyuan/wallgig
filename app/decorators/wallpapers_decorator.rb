class WallpapersDecorator < Draper::CollectionDecorator
  delegate :facets

  # kaminari's pagination
  delegate :current_page, :total_pages, :limit_value, :last_page?

  def decorate_item(item)
    context_with_favourited = context.tap do |c|
      c[:favourited] = user_favourited_wallpaper_ids.include?(item.id)
    end

    item_decorator.call(item, context: context_with_favourited)
  end

  private
    def ids
      object.map(&:id)
    end

    def user_favourited_wallpaper_ids
      return [] if context[:user].blank?
      @user_favourited_wallpaper_ids ||= context[:user].favourites.where(wallpaper_id: ids).pluck(:wallpaper_id)
    end
end