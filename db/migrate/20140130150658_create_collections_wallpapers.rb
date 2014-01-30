class CreateCollectionsWallpapers < ActiveRecord::Migration
  def change
    create_table :collections_wallpapers do |t|
      t.references :collection, index: true
      t.references :wallpaper, index: true
      t.integer :position

      t.timestamps
    end
  end
end
