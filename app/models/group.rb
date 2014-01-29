# == Schema Information
#
# Table name: groups
#
#  id              :integer          not null, primary key
#  owner_id        :integer
#  name            :string(255)
#  slug            :string(255)
#  description     :text
#  admin_title     :string(255)
#  moderator_title :string(255)
#  member_title    :string(255)
#  has_forums      :boolean
#  created_at      :datetime
#  updated_at      :datetime
#  tagline         :string(255)
#  access          :string(255)
#  official        :boolean          default(FALSE)
#

class Group < ActiveRecord::Base
  DEFAULT_ADMIN_TITLE     = 'Administrator'
  DEFAULT_MODERATOR_TITLE = 'Moderator'
  DEFAULT_MEMBER_TITLE    = 'Member'
  DEFAULT_BANNED_TITLE    = 'Banned'

  belongs_to :owner, class_name: 'User'

  has_many :users_groups, dependent: :destroy
  has_many :users, through: :users_groups

  has_many :forums, -> { order(position: :asc) }, dependent: :destroy

  extend FriendlyId
  friendly_id :name, use: :slugged

  extend Enumerize
  enumerize :access, in: [:public, :private, :secret], default: :public

  validates :name,    presence: true, length: { minimum: 5 }, uniqueness: { case_sensitive: false }
  validates :access,  presence: true

  scope :official,   -> { where(official: true) }
  scope :unofficial, -> { where.not(official: true) }

  after_create :create_admin_user!

  def create_admin_user!
    users_groups.create! user_id: owner_id, role: :admin
  end

  def add_member(user)
    users_groups.create user_id: user.id
  end

  def title_for(users_group)
    if users_group.is_a?(User)
      users_group = users_groups.find_by(user_id: users_group.id)
    end

    if users_group.admin?
      admin_title #|| DEFAULT_ADMIN_TITLE
    elsif users_group.moderator?
      moderator_title #|| DEFAULT_MODERATOR_TITLE
    elsif users_group.banned?
      DEFAULT_BANNED_TITLE
    else
      member_title #|| DEFAULT_MEMBER_TITLE
    end
  end
end
