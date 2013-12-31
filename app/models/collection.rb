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
  has_many :favourites, dependent: :nullify
  has_many :wallpapers, through: :favourites

  acts_as_list scope: :user

  is_impressionable counter_cache: true

  validates :name, presence: true

  paginates_per 20

  scope :ordered, -> { order(position: :asc) }
  scope :latest, -> { order(updated_at: :desc) }

  def to_param
    "#{id}-#{name.parameterize}"
  end
end
