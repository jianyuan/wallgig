class CreateScreenResolutions < ActiveRecord::Migration
  def change
    create_table :screen_resolutions do |t|
      t.integer :width
      t.integer :height
      t.string :category
    end
  end
end
