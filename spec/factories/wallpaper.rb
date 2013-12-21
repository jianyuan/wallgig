FactoryGirl.define do
  factory :wallpaper do
    image File.new(Rails.root.join('spec', 'wallpapers', 'test.jpg'))
    processing false
  end
end