json.extract! @wallpaper, :id, :user_id, :purity, :processing, :image_width, :image_height, :created_at, :updated_at
json.standard_image_url @wallpaper.standard_image.url
json.large_image_url @wallpaper.large_image.url
json.thumbnail_image_url @wallpaper.thumbnail_image.url