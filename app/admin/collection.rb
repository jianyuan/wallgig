ActiveAdmin.register Collection do
  menu parent: 'Wallpapers'

  index do
    selectable_column
    column 'Id', sortable: :id do |collection|
      link_to collection.id, admin_collection_path(collection)
    end
    column :name
    column :public, sortable: :public do |collection|
      status_tag collection.public? ? 'Yes' : 'No'
    end
    column :wallpapers_count do |collection|
      collection.wallpapers.size
    end
    column 'Views', :impressions_count
    column :user
    column :created_at
    column :updated_at
    actions
  end

  show do
    panel 'Collection Details' do
      attributes_table_for collection do
        row :name
        row :public
        row :user
        row :impressions_count
        row :created_at
        row :updated_at
      end
    end
    panel 'Wallpapers' do
      table_for collection.wallpapers do
        column :thumbnail do |wallpaper|
          link_to admin_wallpaper_path(wallpaper) do
            image_tag wallpaper.thumbnail_image.url
          end
        end
      end
    end
    active_admin_comments
  end
end