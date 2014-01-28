class AddUsernameColorHexAndTitleToUserProfiles < ActiveRecord::Migration
  def change
    add_column :user_profiles, :username_color_hex, :string
    add_column :user_profiles, :title, :string
  end
end
