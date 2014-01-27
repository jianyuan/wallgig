class AddScreenResolutionToUserSettings < ActiveRecord::Migration
  def change
    add_reference :user_settings, :screen_resolution, index: true
  end
end
