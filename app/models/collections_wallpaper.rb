# == Schema Information
#
# Table name: collections_wallpapers
#
#  id            :integer          not null, primary key
#  collection_id :integer
#  wallpaper_id  :integer
#  position      :integer
#  created_at    :datetime
#  updated_at    :datetime
#

class CollectionsWallpaper < ActiveRecord::Base
  belongs_to :collection
  belongs_to :wallpaper

  validates :collection_id, presence: true
  validates :wallpaper_id, presence: true

  acts_as_list
end
