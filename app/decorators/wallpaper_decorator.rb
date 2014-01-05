class WallpaperDecorator < Draper::Decorator
  delegate_all

  def resolution
    "#{image_width}x#{image_height}"
  end

  def favourite_button
    url = h.toggle_wallpaper_favourite_path(wallpaper, format: :json)
    options = {
      class: 'btn btn-sm btn-like pull-left',
      method: :post,
      remote: true,
      data: {
        action: 'like'
      }
    }
    options[:class] << ' btn-success' if context[:favourited]

    puts context

    h.link_to url, options do
      "<span class='glyphicon glyphicon-thumbs-up'></span>" \
      "<span class='count'>#{favourites_count}</span>".html_safe
    end
  end
end