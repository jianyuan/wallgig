# == Schema Information
#
# Table name: forum_topics
#
#  id             :integer          not null, primary key
#  forum_id       :integer
#  user_id        :integer
#  title          :string(255)
#  content        :text
#  cooked_content :text
#  pinned         :boolean          default(FALSE)
#  locked         :boolean          default(FALSE)
#  hidden         :boolean          default(FALSE)
#  created_at     :datetime
#  updated_at     :datetime
#

class ForumTopic < ActiveRecord::Base
  belongs_to :forum
  belongs_to :user

  validates :forum_id, presence: true
  validates :user_id,  presence: true
  validates :title,    presence: true, length: { minimum: 10 }
  validates :content,  presence: true, length: { minimum: 20 }

  scope :pinned_first, -> { order(pinned: :desc) }
  scope :latest,       -> { order(updated_at: :desc) }

  before_save do
    self.cooked_content = ApplicationController.helpers.markdown(content) if content_changed?
  end

  def to_param
    "#{id}-#{title.parameterize}"
  end

  def cooked_content
    read_attribute(:cooked_content).try(:html_safe)
  end

  def pin!
    self.pinned = true
    self.save!
  end

  def unpin!
    self.pinned = false
    self.save!
  end

  def lock!
    self.locked = true
    self.save!
  end

  def unlock!
    self.locked = false
    self.save!
  end

  def hide!
    self.hidden = true
    self.save!
  end

  def unhide!
    self.hidden = false
    self.save!
  end
end
