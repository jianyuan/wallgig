class CreateUserSettings < ActiveRecord::Migration
  def change
    create_table :user_settings do |t|
      t.references :user, index: {:unique=>true}
      t.boolean :sfw,             default: true
      t.boolean :sketchy,         default: false
      t.boolean :nsfw,            default: false
      t.integer :per_page,        default: 20
      t.boolean :infinite_scroll, default: true
      t.integer :screen_width
      t.integer :screen_height
      t.string :country_code

      t.timestamps
    end
  end
end
