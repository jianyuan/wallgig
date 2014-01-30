class RemoveRoleFromUsersGroup < ActiveRecord::Migration
  def change
    remove_column :users_groups, :role, :integer
  end
end
