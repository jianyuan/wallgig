class AddImpressionsCountToCollections < ActiveRecord::Migration
  def change
    add_column :collections, :impressions_count, :integer, default: 0
  end
end
