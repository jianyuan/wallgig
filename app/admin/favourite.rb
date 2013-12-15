ActiveAdmin.register Favourite do
  menu parent: 'Wallpapers'

  actions :index

  index do
    column :id
    column :user
    column 'Wallpaper' do |favourite|
      link_to admin_wallpaper_path(favourite.wallpaper) do
        image_tag favourite.wallpaper.thumbnail_image.url, width: 125, height: 94
      end
    end
    column :collection
    column :created_at
  end
end