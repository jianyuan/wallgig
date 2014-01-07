# == Schema Information
#
# Table name: favourites
#
#  id            :integer          not null, primary key
#  user_id       :integer
#  wallpaper_id  :integer
#  collection_id :integer
#  created_at    :datetime
#  updated_at    :datetime
#

require 'spec_helper'

describe Favourite do
  describe 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:wallpaper).counter_cache(true) }
    it { should belong_to(:collection).touch(true) }
  end
end
