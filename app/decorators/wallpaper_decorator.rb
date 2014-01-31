class WallpaperDecorator < Draper::Decorator
  delegate_all

  def requested_image_url
    return if image.blank?
    return resized_image.url if resized_image.present?

    if Rails.env.production?
      "#{ENV['CDN_HOST']}#{image.remote_url}"
    else
      image.url
    end
  end

  def requested_image_width
    resized_image_resolution.present? ? resized_image_resolution.width : image_width
  end

  def requested_image_height
    resized_image_resolution.present? ? resized_image_resolution.height : image_height
  end

  def path_with_resolution
    if context[:search_options].present? && context[:search_options][:width].present? && context[:search_options][:height].present?
      h.resized_wallpaper_path(self, width: context[:search_options][:width], height: context[:search_options][:height])
    else
      h.wallpaper_path(self)
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
    url = h.toggle_favourite_wallpaper_path(wallpaper)
    options = {
      class: 'btn btn-sm pull-left',
      data: {
        action: 'favourite',
        method: :post,
        remote: true
      }
    }
    options[:class] << ' btn-info' if context[:favourited]

    h.link_to url, options do
      "<span class='glyphicon glyphicon-star'></span>" \
      "<span class='count'>#{cached_votes_total}</span>".html_safe
    end
  end

  def resolution_select_tag
    h.select_tag 'resolution',
                 h.grouped_options_for_select(resolutions.array_for_options, "#{requested_image_width}x#{requested_image_height}", prompt: "#{resolution} (Original)".html_safe),
                 class: 'form-control',
                 data: { action: 'resize', url: h.wallpaper_path(self) }
  end
end