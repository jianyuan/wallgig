class AddDiscourseUserIdToUsers < ActiveRecord::Migration
  def change
    add_reference :users, :discourse_user, index: true
  end
end
