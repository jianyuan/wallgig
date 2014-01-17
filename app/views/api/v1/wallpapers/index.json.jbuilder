json.wallpapers do
  json.array! @wallpapers do |wallpaper|
    json.extract! wallpaper, :id
    json.url wallpaper_url(wallpaper)
    json.owner do
      json.extract! wallpaper.user, :id, :username
    end
    json.extract! wallpaper, :purity
    json.image do
      json.thumbnail do
        json.width 250
        json.height 188
        json.url wallpaper.thumbnail_image_url
      end
    end
  end
end

json.pagination do
  json.total_count @wallpapers.total_count
  json.per_page @wallpapers.limit_value
  json.current_page @wallpapers.current_page
  json.total_pages @wallpapers.total_pages
  json.next_url @wallpapers.next_page.present? ? url_for(page: @wallpapers.next_page) : nil
  json.previous_url @wallpapers.prev_page.present? ? url_for(page: @wallpapers.prev_page) : nil
end
