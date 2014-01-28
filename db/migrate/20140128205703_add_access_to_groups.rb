class AddAccessToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :access, :string
    add_index :groups, :access
  end
end
