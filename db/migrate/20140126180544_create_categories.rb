class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :name
      t.string :slug
      t.string :wikipedia_title
      t.text :raw_content
      t.text :cooked_content
      t.string :ancestry

      t.timestamps
    end
    add_index :categories, :slug, unique: true
    add_index :categories, :ancestry
  end
end
