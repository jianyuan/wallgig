class AddOfficialToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :official, :boolean, default: false
  end
end
