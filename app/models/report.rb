# == Schema Information
#
# Table name: reports
#
#  id              :integer          not null, primary key
#  reportable_id   :integer
#  reportable_type :string(255)
#  user_id         :integer
#  description     :text
#  closed_by_id    :integer
#  closed_at       :datetime
#  created_at      :datetime
#  updated_at      :datetime
#

class Report < ActiveRecord::Base
  belongs_to :reportable, polymorphic: true
  belongs_to :user
  belongs_to :closed_by, class_name: 'User'

  validates :reportable, presence: true
  validates :description, presence: true

  scope :closed, -> { where.not(closed_at: nil) }
  scope :open,   -> { where(closed_at: nil) }

  def closed?
    closed_at.present?
  end

  def close_by_user!(user)
  	self.closed_by = user
  	self.closed_at = Time.now
  	save!
  end

  def open!
    self.closed_by = nil
    self.closed_at = nil
    save!
  end
end
