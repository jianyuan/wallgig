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
#

require 'spec_helper'

describe Wallpaper do
  describe 'associations' do
    it { should belong_to(:user).counter_cache(true) }
    it { should have_many(:wallpaper_colors).dependent(:destroy) }
    it { should have_many(:colors).through(:wallpaper_colors).class_name('Kolor') }
    it { should belong_to(:primary_color).class_name('Kolor') }
    it { should have_many(:favourites).dependent(:destroy) }
    it { should have_many(:favourited_users).through(:favourites).source(:wallpaper) }
    it { should have_many(:reports).dependent(:destroy) }
  end

  describe 'validations' do
    it { should validate_presence_of(:purity) }
    it { should validate_presence_of(:image) }
  end

  context 'tags' do
    context 'when empty' do
      subject { create(:wallpaper, tag_list: nil) }
      it { expect(subject.tag_list).to include('tagme') }
    end

    context 'when present' do
      subject { create(:wallpaper, tag_list: ['tagme', 'tag']) }
      it { expect(subject.tag_list).not_to include('tagme') }
    end
  end
end
