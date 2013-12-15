# == Schema Information
#
# Table name: collections
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  name       :string(255)
#  public     :boolean
#  ancestry   :string(255)
#  position   :integer
#  created_at :datetime
#  updated_at :datetime
#

class Collection < ActiveRecord::Base
  belongs_to :user
  has_many :favourites, dependent: :nullify
  has_many :wallpapers, through: :favourites

  acts_as_list scope: :user

  validates :name, presence: true

  scope :ordered, -> { order position: :asc }

  def to_param
    "#{id}-#{name.parameterize}"
  end
end