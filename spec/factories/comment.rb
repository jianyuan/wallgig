FactoryGirl.define do
  factory :comment do
    title 'Comment title'
    comment 'Comment text'
    user
  end
end