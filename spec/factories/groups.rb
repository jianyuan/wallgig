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

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :group do
    owner nil
    name "MyString"
    slug "MyString"
    description "MyText"
    public false
    admin_title "MyString"
    moderator_title "MyString"
    member_title "MyString"
    has_forums false
  end
end
