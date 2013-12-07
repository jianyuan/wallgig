class CreateWallpapers < ActiveRecord::Migration
  def change
    create_table :wallpapers do |t|
      t.references :user, index: true
      t.string :purity
      t.boolean :processing, default: true
      t.string :image
      t.integer :image_width
      t.integer :image_height

      t.timestamps
    end
  end
end
