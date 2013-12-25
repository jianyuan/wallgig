json.count @wallpaper.favourites.count
json.favourite @wallpaper.favourites.exists?(user: current_user)