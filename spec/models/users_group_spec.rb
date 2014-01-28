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

require 'spec_helper'

describe UsersGroup do
  pending "add some examples to (or delete) #{__FILE__}"
end
