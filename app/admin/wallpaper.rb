ActiveAdmin.register Wallpaper do

  
  # See permitted parameters documentation:
  # https://github.com/gregbell/active_admin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # permit_params :list, :of, :attributes, :on, :model
  #
  # or
  #
  # permit_params do
  #  permitted = [:permitted, :attributes]
  #  permitted << :other if resource.something?
  #  permitted
  # end

  index do
    selectable_column
    column 'Id', sortable: :id do |wallpaper|
      link_to wallpaper.id, admin_wallpaper_path(wallpaper)
    end
    column 'Thumbnail' do |wallpaper|
      link_to admin_wallpaper_path(wallpaper) do
        image_tag wallpaper.thumbnail_image.url
      end
    end
    column :purity
    column 'Tags', :cached_tag_list, sortable: false
    column 'Views', :impressions_count
    column 'User' do |wallpaper|
      return if wallpaper.user.blank?
      link_to wallpaper.user.username, admin_user_path(wallpaper.user)
    end
    column :processing
    column :created_at
    column :updated_at
    default_actions
  end

end