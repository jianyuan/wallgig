class CreateUsersGroups < ActiveRecord::Migration
  def change
    create_table :users_groups do |t|
      t.references :user, index: true
      t.references :group, index: true
      t.integer :role

      t.timestamps
    end
  end
end
