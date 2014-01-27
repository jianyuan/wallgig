# == Schema Information
#
# Table name: user_settings
#
#  id              :integer          not null, primary key
#  user_id         :integer
#  sfw             :boolean          default(TRUE)
#  sketchy         :boolean          default(FALSE)
#  nsfw            :boolean          default(FALSE)
#  per_page        :integer          default(20)
#  infinite_scroll :boolean          default(TRUE)
#  screen_width    :integer
#  screen_height   :integer
#  country_code    :string(255)
#  created_at      :datetime
#  updated_at      :datetime
#

require 'spec_helper'

describe UserSetting do
  pending "add some examples to (or delete) #{__FILE__}"
end
