class RemovePublicFromGroups < ActiveRecord::Migration
  def change
    remove_column :groups, :public, :boolean
  end
end
