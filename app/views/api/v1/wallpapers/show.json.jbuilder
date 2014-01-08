json.extract! @wallpaper, :id
json.url wallpaper_url(@wallpaper)
json.owner do
  json.extract! @wallpaper.user, :id, :username
end
json.extract! @wallpaper, :purity
json.image do
  json.file_name @wallpaper.image_name
  json.gravity @wallpaper.image_gravity
  json.original do
    json.width @wallpaper.image_width
    json.height @wallpaper.image_height
    json.url @wallpaper.requested_image_url
  end
  json.thumbnail do
    json.width 250
    json.height 188
    json.url @wallpaper.thumbnail_image_url
  end
end
json.tags @wallpaper.tag_list
json.source @wallpaper.source.presence
json.extract! @wallpaper, :created_at, :updated_at