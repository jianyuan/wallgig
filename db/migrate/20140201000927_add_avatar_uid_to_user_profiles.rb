class AddAvatarUidToUserProfiles < ActiveRecord::Migration
  def change
    add_column :user_profiles, :avatar_uid, :string
  end
end
