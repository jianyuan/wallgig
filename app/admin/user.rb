ActiveAdmin.register User do

  
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

  controller do
    def resource
      User.find_by!(username: params[:id])
    end
  end

  index do
    selectable_column
    column 'Username', sortable: :username do |user|
      link_to user.username, admin_user_path(user)
    end
    column 'Avatar' do |user|
      link_to admin_user_path(user) do
        image_tag gravatar_url(user, 48)
      end
    end
    column :sign_in_count
    column :current_sign_in_at
    column :last_sign_in_at
    column :current_sign_in_ip, sortable: false
    column :last_sign_in_ip, sortable: false
    column :created_at
    column :updated_at
    default_actions
  end

end