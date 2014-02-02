ActiveAdmin.register User do
  actions :all, except: [:destroy]

  permit_params :email, :username, :password, :moderator, :admin, :developer, :locked_at

  %i(email username moderator admin developer).each do |a|
    filter a
  end

  index do
    selectable_column
    column 'Username', sortable: :username do |user|
      link_to user.username, admin_user_path(user)
    end
    column 'Role' do |user|
      role_name_for(user)
    end
    column 'Avatar' do |user|
      link_to admin_user_path(user) do
        image_tag gravatar_url(user, 48)
      end
    end
    column :sign_in_count
    column :current_sign_in_at
    column :last_sign_in_at
    column :confirmed_at
    column :failed_attempts
    column :locked_at
    column :created_at
    column :updated_at
    default_actions
  end

  form do |f|
    f.inputs do
      f.input :email
      f.input :username
      f.input :password
      f.input :moderator
      f.input :admin
      f.input :developer
    end
    f.actions
  end

  controller do
    def resource
      User.find_by!(username: params[:id])
    end
  end
end