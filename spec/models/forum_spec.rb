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

require 'spec_helper'

describe Forum do
  pending "add some examples to (or delete) #{__FILE__}"
end
