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

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :category do
    name "MyString"
    slug "MyString"
    wikipedia_title "MyString"
    description "MyText"
    ancestry "MyString"
  end
end
