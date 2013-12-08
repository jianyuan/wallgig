class CreateColors < ActiveRecord::Migration
  def change
    create_table :colors do |t|
      t.integer :red
      t.integer :green
      t.integer :blue
      t.string :hex
    end
    add_index :colors, :hex, unique: true
  end
end
