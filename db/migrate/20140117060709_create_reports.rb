class CreateReports < ActiveRecord::Migration
  def change
    create_table :reports do |t|
      t.references :reportable, polymorphic: true, index: true
      t.references :user, index: true
      t.text :description
      t.references :closed_by, index: true
      t.datetime :closed_at

      t.timestamps
    end
  end
end
