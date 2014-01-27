class AddCookedCommentToComments < ActiveRecord::Migration
  def change
    add_column :comments, :cooked_comment, :text
  end
end
