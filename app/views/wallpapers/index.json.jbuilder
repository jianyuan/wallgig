json.array!(@wallpapers) do |wallpaper|
  json.extract! wallpaper, :id, :user_id, :purity, :processing, :image, :image_width, :image_height
  json.url wallpaper_url(wallpaper, format: :json)
end
