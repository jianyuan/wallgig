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

class UserSetting < ActiveRecord::Base
  belongs_to :user

  extend Enumerize
  enumerize :per_page, in: [20, 40, 60], default: 20

  def purities
    out = []
    out << :sfw     if sfw?
    out << :sketchy if sketchy?
    out << :nsfw    if nsfw?
    out
  end
end
