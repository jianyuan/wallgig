ActiveAdmin.register_page "Dashboard" do

  menu :priority => 1, :label => proc{ I18n.t("active_admin.dashboard") }

  content :title => proc{ I18n.t("active_admin.dashboard") } do
    columns do
      column do
        panel 'Recent Wallpapers' do
          ul do
            Wallpaper.order(created_at: :desc).includes(:user).map do |wallpaper|
              li link_to("Uploaded by #{wallpaper.user.try(:username)} #{time_ago_in_words(wallpaper.created_at)} ago", admin_wallpaper_path(wallpaper))
            end
          end
        end
      end
      column do
        panel 'Recent Sign Ups' do
          ul do
            User.order(created_at: :desc).limit(10).map do |user|
              li link_to("#{user.username} #{time_ago_in_words(user.created_at)} ago", admin_user_path(user))
            end
          end
        end
      end
    end

    # div :class => "blank_slate_container", :id => "dashboard_default_message" do
    #   span :class => "blank_slate" do
    #     span I18n.t("active_admin.dashboard_welcome.welcome")
    #     small I18n.t("active_admin.dashboard_welcome.call_to_action")
    #   end
    # end

    # Here is an example of a simple dashboard with columns and panels.
    #
    # columns do
    #   column do
    #     panel "Recent Posts" do
    #       ul do
    #         Post.recent(5).map do |post|
    #           li link_to(post.title, admin_post_path(post))
    #         end
    #       end
    #     end
    #   end

    #   column do
    #     panel "Info" do
    #       para "Welcome to ActiveAdmin."
    #     end
    #   end
    # end
  end # content
end
