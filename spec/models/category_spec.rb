# == Schema Information
#
# Table name: categories
#
#  id              :integer          not null, primary key
#  name            :string(255)
#  slug            :string(255)
#  wikipedia_title :string(255)
#  raw_content     :text
#  cooked_content  :text
#  ancestry        :string(255)
#  created_at      :datetime
#  updated_at      :datetime
#

require 'spec_helper'

describe Category do
  pending "add some examples to (or delete) #{__FILE__}"
end
