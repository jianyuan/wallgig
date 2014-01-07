FactoryGirl.define do
  factory :user do
    sequence(:username) { |n| "user#{n}" }
    sequence(:email) { |n| "user#{n}@example.com" }
    password '12345678'

    after(:create) { |user| user.confirm! }
  end
end