class CreateCollections < ActiveRecord::Migration
  def change
    create_table :collections do |t|
      t.references :user, index: true
      t.string :name
      t.boolean :public, default: true
      t.string :ancestry
      t.integer :position

      t.timestamps
    end
    add_index :collections, :ancestry
  end
end
