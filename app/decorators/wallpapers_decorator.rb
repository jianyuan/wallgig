class WallpapersDecorator < Draper::CollectionDecorator
  # pagination
  delegate :total_count, :limit_value, :current_page, :total_pages, :next_page, :prev_page, :last_page?

  def facets
    object.kind_of?(Tire::Results::Collection) ? object.facets : []
  end

  def link_to_next_page
    return unless has_pagination?
    h.link_to_next_page object, 'Next Page', class: 'btn btn-block btn-default btn-lg', params: context[:search_options]
  end

  protected
    def decorate_item(item)
      context_with_favourited = context.dup
      context_with_favourited[:favourited] = user_favourited_wallpaper_ids.include?(item.id)

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

    def has_pagination?
      object.kind_of?(Kaminari::PageScopeMethods) || object.kind_of?(Tire::Results::Pagination)
    end
end