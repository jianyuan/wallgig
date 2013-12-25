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
#

require 'spec_helper'

describe Wallpaper do
  describe 'associations' do
    it { should belong_to(:user) }
    it { should have_many(:wallpaper_colors) }
    it { should have_many(:colors) }
    it { should belong_to(:primary_color) }
    it { should have_many(:favourites) }
    it { should have_many(:favourited_users) }
  end

  describe 'validations' do
    it { should validate_presence_of(:image) }
  end
end
