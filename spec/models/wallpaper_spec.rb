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
