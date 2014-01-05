class WallpaperDecorator < Draper::Decorator
  delegate_all

  def image_url
    return if image.blank?
    if Rails.env.production?
      "#{ENV['CDN_HOST']}#{image.remote_url}"
    else
      image.url
    end
  end

  def thumbnail_image_url
    return if thumbnail_image.blank?
    if Rails.env.production?
      "#{ENV['CDN_HOST']}#{thumbnail_image.remote_url}"
    else
      thumbnail_image.url
    end
  end

  def resolution
    "#{image_width}&times;#{image_height}".html_safe
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

    h.link_to url, options do
      "<span class='glyphicon glyphicon-thumbs-up'></span>" \
      "<span class='count'>#{favourites_count}</span>".html_safe
    end
  end
end