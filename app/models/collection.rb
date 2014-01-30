# == Schema Information
#
# Table name: collections
#
#  id                :integer          not null, primary key
#  user_id           :integer
#  name              :string(255)
#  public            :boolean          default(TRUE)
#  ancestry          :string(255)
#  position          :integer
#  created_at        :datetime
#  updated_at        :datetime
#  impressions_count :integer          default(0)
#

class Collection < ActiveRecord::Base
  belongs_to :user
  # has_many :favourites, dependent: :nullify
  has_many :collections_wallpapers, dependent: :destroy
  has_many :wallpapers, -> { order('collections_wallpapers.position ASC') }, through: :collections_wallpapers

  acts_as_list scope: :user

  is_impressionable counter_cache: true

  validates :name, presence: true

  paginates_per 20

  scope :ordered, -> { order(position: :asc) }
  scope :latest, -> { order(updated_at: :desc) }

  attr_accessor :collect_status

  def to_param
    "#{id}-#{name.parameterize}"
  end

  def collected?(wallpaper)
    collections_wallpapers.where(wallpaper_id: wallpaper.id).exists?
  end

  def uncollect(wallpaper)
    collections_wallpapers.find_by!(wallpaper_id: wallpaper.id).destroy
  end

  def collect(wallpaper)
    collections_wallpapers.create(wallpaper_id: wallpaper.id)
  end
end
