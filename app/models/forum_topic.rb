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
#  pinned         :boolean          default(TRUE)
#  locked         :boolean          default(TRUE)
#  hidden         :boolean          default(TRUE)
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

  def to_param
    "#{id}-#{title.parameterize}"
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
