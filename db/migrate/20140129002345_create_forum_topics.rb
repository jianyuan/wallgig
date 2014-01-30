class CreateForumTopics < ActiveRecord::Migration
  def change
    create_table :forum_topics do |t|
      t.references :forum, index: true
      t.references :user, index: true
      t.string :title
      t.text :content
      t.text :cooked_content
      t.boolean :pinned, default: false
      t.boolean :locked, default: false
      t.boolean :hidden, default: false

      t.timestamps
    end
  end
end
