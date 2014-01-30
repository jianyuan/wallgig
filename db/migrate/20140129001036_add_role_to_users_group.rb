class AddRoleToUsersGroup < ActiveRecord::Migration
  def change
    add_column :users_groups, :role, :string
    add_index :users_groups, :role
  end
end
