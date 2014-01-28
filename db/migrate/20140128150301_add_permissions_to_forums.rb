class AddPermissionsToForums < ActiveRecord::Migration
  def change
    add_column :forums, :guest_can_read, :boolean, default: true
    add_column :forums, :guest_can_post, :boolean, default: true
    add_column :forums, :guest_can_reply, :boolean, default: true
    add_column :forums, :member_can_read, :boolean, default: true
    add_column :forums, :member_can_post, :boolean, default: true
    add_column :forums, :member_can_reply, :boolean, default: true
  end
end
