json.toggle_collect_url toggle_collect_wallpaper_path(@wallpaper)
json.collections @collections do |collection|
  json.extract! collection, :id, :name, :public, :collect_status
end
