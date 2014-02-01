class AddOwnerToCollections < ActiveRecord::Migration
  def change
    add_reference :collections, :owner, polymorphic: true, index: true
  end
end
