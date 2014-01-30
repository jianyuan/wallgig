# == Schema Information
#
# Table name: forums
#
#  id               :integer          not null, primary key
#  group_id         :integer
#  name             :string(255)
#  slug             :string(255)
#  description      :text
#  position         :integer
#  created_at       :datetime
#  updated_at       :datetime
#  guest_can_read   :boolean          default(TRUE)
#  guest_can_post   :boolean          default(TRUE)
#  guest_can_reply  :boolean          default(TRUE)
#  member_can_read  :boolean          default(TRUE)
#  member_can_post  :boolean          default(TRUE)
#  member_can_reply :boolean          default(TRUE)
#

class Forum < ActiveRecord::Base
  belongs_to :group
  has_many :topics, class_name: 'ForumTopic'

  extend FriendlyId
  friendly_id :name, use: [:slugged, :scoped], scope: :group

  acts_as_list scope: :group

  validates :group_id, presence: true
  validates :name, presence: true
end
