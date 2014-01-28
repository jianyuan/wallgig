class CreateUserProfiles < ActiveRecord::Migration
  def change
    create_table :user_profiles do |t|
      t.references :user, index: {:unique=>true}
      t.references :cover_wallpaper, index: true
      t.integer :cover_wallpaper_y_offset
      t.string :country_code

      t.timestamps
    end
  end
end
