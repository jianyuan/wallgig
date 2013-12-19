json.extract! @wallpaper, :id, :purity, :image_width, :image_height
json.image_url @wallpaper.image.url
json.thumbnail_image_url @wallpaper.thumbnail_image.url
json.extract! @wallpaper, :impressions_count, :favourites_count, :created_at, :updated_at