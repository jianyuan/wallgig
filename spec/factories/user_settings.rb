# == Schema Information
#
# Table name: user_settings
#
#  id                   :integer          not null, primary key
#  user_id              :integer
#  sfw                  :boolean          default(TRUE)
#  sketchy              :boolean          default(FALSE)
#  nsfw                 :boolean          default(FALSE)
#  per_page             :integer          default(20)
#  infinite_scroll      :boolean          default(TRUE)
#  screen_width         :integer
#  screen_height        :integer
#  country_code         :string(255)
#  created_at           :datetime
#  updated_at           :datetime
#  screen_resolution_id :integer
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user_setting do
    user nil
    sfw false
    sketchy false
    nsfw false
    per_page 1
    infinite_scroll false
    screen_width 1
    screen_height 1
    country_code "MyString"
  end
end
