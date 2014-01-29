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

require 'spec_helper'

describe ForumTopic do
  pending "add some examples to (or delete) #{__FILE__}"
end
