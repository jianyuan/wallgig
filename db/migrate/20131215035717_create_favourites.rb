class CreateFavourites < ActiveRecord::Migration
  def change
    create_table :favourites do |t|
      t.references :user, index: true
      t.references :wallpaper, index: true
      t.references :collection, index: true

      t.timestamps
    end
  end
end
