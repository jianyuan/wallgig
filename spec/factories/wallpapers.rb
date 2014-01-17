# == Schema Information
#
# Table name: wallpapers
#
#  id                  :integer          not null, primary key
#  user_id             :integer
#  purity              :string(255)
#  processing          :boolean          default(TRUE)
#  image_uid           :string(255)
#  image_name          :string(255)
#  image_width         :integer
#  image_height        :integer
#  created_at          :datetime
#  updated_at          :datetime
#  thumbnail_image_uid :string(255)
#  primary_color_id    :integer
#  impressions_count   :integer          default(0)
#  cached_tag_list     :text
#  image_gravity       :string(255)
#  favourites_count    :integer          default(0)
#  purity_locked       :boolean          default(FALSE)
#  source              :string(255)
#  phash               :integer
#  scrape_source       :string(255)
#  scrape_id           :string(255)
#  image_hash          :string(255)
#

FactoryGirl.define do
  factory :wallpaper do
    user
    image File.new(Rails.root.join('spec', 'wallpapers', 'test.jpg'))
    processing false

    factory(:sfw_wallpaper) { purity :sfw }
    factory(:sketchy_wallpaper) { purity :sketchy }
    factory(:nsfw_wallpaper) { purity :nsfw }
  end
end
