FactoryGirl.define do
  factory :user do
    username { "user#{Random.rand(0..1000)}" }
    email    { "user#{Random.rand(0..1000)}@gmail.com" }
    password '12345678'

    after(:create) { |user| user.confirm! }
  end
end