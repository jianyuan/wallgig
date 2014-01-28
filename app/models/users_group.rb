# == Schema Information
#
# Table name: users_groups
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  group_id   :integer
#  role       :integer
#  created_at :datetime
#  updated_at :datetime
#

class UsersGroup < ActiveRecord::Base
  belongs_to :user
  belongs_to :group

  extend Enumerize
  enumerize :role, in: { admin: 1, moderator: 2, banned: -1 }

  validates :user_id,  presence: true, uniqueness: { scope: [:group_id], message: 'already joined this group' }
  validates :group_id, presence: true
end
