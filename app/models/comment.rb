# == Schema Information
#
# Table name: comments
#
#  id               :integer          not null, primary key
#  title            :string(50)       default("")
#  comment          :text
#  commentable_id   :integer
#  commentable_type :string(255)
#  user_id          :integer
#  role             :string(255)      default("comments")
#  created_at       :datetime
#  updated_at       :datetime
#

class Comment < ActiveRecord::Base
  include ActsAsCommentable::Comment

  belongs_to :commentable, polymorphic: true

  scope :latest, -> { reorder('created_at DESC') }
  default_scope -> { order('created_at ASC') }

  # NOTE: install the acts_as_votable plugin if you
  # want user to vote on the quality of comments.
  #acts_as_voteable

  belongs_to :user

  validates :comment, presence: true
  validates :user, presence: true
end