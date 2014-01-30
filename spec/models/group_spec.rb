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

require 'spec_helper'

describe Group do
  pending "add some examples to (or delete) #{__FILE__}"
end
