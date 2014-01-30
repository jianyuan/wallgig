class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.references :owner, index: true
      t.string :name
      t.string :slug
      t.text :description
      t.boolean :public, default: true
      t.string :admin_title
      t.string :moderator_title
      t.string :member_title
      t.boolean :has_forums

      t.timestamps
    end
    add_index :groups, :slug, unique: true
  end
end
