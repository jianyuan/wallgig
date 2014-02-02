ActiveAdmin.register Wallpaper do
  permit_params :purity, :purity_locked, :tag_list

  batch_action :purity_lock do |selection|
    Wallpaper.find(selection).each &:lock_purity!
    redirect_to :back, notice: 'Wallpaper purities locked!'
  end

  batch_action :update_index do |selection|
    Wallpaper.find(selection).each &:update_index
    redirect_to :back, notice: 'Wallpaper indices updated!'
  end

  batch_action :reprocess do |selection|
    Wallpaper.find(selection).each &:queue_create_thumbnails
    Wallpaper.find(selection).each &:queue_process_image
    redirect_to :back, notice: 'Wallpaper queued for reprocessing!'
  end

  %i(user tags purity purity_locked processing image_width image_height source created_at updated_at).each do |a|
    filter a
  end

  index do
    selectable_column
    column 'Id', sortable: :id do |wallpaper|
      link_to wallpaper.id, admin_wallpaper_path(wallpaper)
    end
    column 'Thumbnail' do |wallpaper|
      link_to admin_wallpaper_path(wallpaper) do
        if wallpaper.thumbnail_image.present?
          image_tag wallpaper.thumbnail_image.url, width: 125, height: 94
        else
          'Processing'
        end
      end
    end
    column 'Purity', sortable: :purity do |wallpaper|
      status_tag wallpaper.purity_text
    end
    column :purity_locked
    column 'Tags', :cached_tag_list, sortable: false
    column 'Views', :impressions_count
    column 'Favourites', sortable: :favourites_count do |wallpaper|
      link_to wallpaper.favourites_count, admin_favourites_path(q: { wallpaper_id_eq: wallpaper })
    end
    column :user
    column :processing, sortable: :processing do |wallpaper|
      status_tag wallpaper.processing? ? 'Yes' : 'No'
    end
    column :created_at
    column :updated_at
    actions
  end

  show do
    panel 'Wallpaper Details' do
      attributes_table_for wallpaper do
        row :user
        row :purity, &:purity_text
        row :purity_locked
        row :tag_list
        row :source
        row :primary_color do |wallpaper|
          content_tag :div, nil, style: "width: 50px; height: 50px; background-color: #{wallpaper.primary_color.to_html_hex}" if wallpaper.primary_color.present?
        end
        row :color do |wallpaper|
          ul style: 'list-style: none; padding: 0' do
            wallpaper.wallpaper_colors.map do |wallpaper_color|
              li wallpaper_color.percentage.round(2), style: "display: inline-block; width: 50px; height: 50px; background-color: #{wallpaper_color.to_html_hex}"
            end
          end
        end
        row :created_at
        row :updated_at
      end
    end
    panel 'Image' do
      attributes_table_for wallpaper do
        row :processing do |wallpaper|
          status_tag wallpaper.processing? ? 'Yes' : 'No'
        end
        row :image do
          link_to wallpaper.image.url do
            if wallpaper.thumbnail_image.present?
              image_tag wallpaper.thumbnail_image.url
            else
              'View original image'
            end
          end
        end
        row :image_uid
        row :image_name
        row :image_width
        row :image_height
        row :thumbnail_image_uid
        row :image_gravity, &:image_gravity_text
        row :phash do |wallpaper|
          content_tag :code, wallpaper.phash
        end
        row :scrape_source
        row :scrape_id
      end
    end
    panel 'Stats' do
      attributes_table_for wallpaper do
        row :impressions_count
        row :favourites_count
      end
    end
    if wallpaper.similar_wallpapers.any?
      panel 'Similar Images' do
        table_for wallpaper.similar_wallpapers do
          column :thumbnail do |similar_wallpaper|
            link_to admin_wallpaper_path(similar_wallpaper) do
              if similar_wallpaper.thumbnail_image.present?
                image_tag similar_wallpaper.thumbnail_image.url
              else
                "Wallpaper \##{similar_wallpaper.id}"
              end
            end
          end
        end        
      end
    end
    active_admin_comments
  end

  form do |f|
    f.inputs do
      f.input :purity
      f.input :purity_locked
      f.input :tag_list
      f.input :image_gravity
    end
    f.actions
  end

  member_action :merge_wallpaper do
    @wallpaper = Wallpaper.find(params[:id])
  end

  member_action :perform_wallpaper_merge, method: :post do
    @from_wallpaper = Wallpaper.find(params[:id])
    @to_wallpaper = Wallpaper.find(params[:target_id])
    WallpaperMerger.from(@from_wallpaper).to(@to_wallpaper).execute

    redirect_to admin_wallpaper_path(@to_wallpaper), notice: 'Wallpapers merged!'
  end

  action_item only: :show do
    link_to 'Merge Wallpaper', merge_wallpaper_admin_wallpaper_path(wallpaper)
  end

  controller do
    def scoped_collection
      Wallpaper.includes(:user)
    end
  end
end