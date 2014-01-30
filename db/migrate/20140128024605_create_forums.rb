class CreateForums < ActiveRecord::Migration
  def change
    create_table :forums do |t|
      t.references :group, index: true
      t.string :name
      t.string :slug
      t.text :description
      t.integer :position

      t.timestamps
    end
    add_index :forums, :slug
  end
end
