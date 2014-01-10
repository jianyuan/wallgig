class CreateTagLinks < ActiveRecord::Migration
  def change
    create_table :tag_links do |t|
      t.references :parent, index: true
      t.references :child, index: true

      t.timestamps
    end
  end
end
