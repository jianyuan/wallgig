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

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :forum_topic do
    forum nil
    user nil
    title "MyString"
    content "MyText"
    cooked_content "MyText"
    pinned false
    locked false
    hidden false
  end
end
