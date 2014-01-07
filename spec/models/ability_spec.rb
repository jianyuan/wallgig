require 'spec_helper'
require 'cancan/matchers'

describe Ability do
  subject(:ability) { Ability.new(user) }
  let(:user) { nil }
  let(:another_user) { create(:user) }
  let(:my_new_wallpaper) { build(:wallpaper, user: user) }
  let(:my_wallpaper) { create(:wallpaper, user: user) }
  let(:not_my_wallpaper) { create(:wallpaper, user: another_user) }

  context 'guests' do
    context 'wallpapers' do
      it { should be_able_to :read, build(:sfw_wallpaper) }
      it { should_not be_able_to :read, build(:sketchy_wallpaper) }
      it { should_not be_able_to :read, build(:nsfw_wallpaper) }
      it { should_not be_able_to :create, my_new_wallpaper }
      it { should_not be_able_to [:update, :destroy], not_my_wallpaper }
    end
  end

  context 'members' do
    let!(:user) { create(:user) }

    context 'wallpapers' do
      context 'mine' do
        it { should be_able_to :create, my_new_wallpaper }
        it { should be_able_to :update, my_wallpaper }
      end

      context 'not mine' do
        it { should be_able_to :update, not_my_wallpaper }
        it { should_not be_able_to :destroy, not_my_wallpaper }
      end

      context 'purity locked' do
        it { should_not be_able_to :update_purity, build(:wallpaper, user: user, purity_locked: true) }
      end
    end

    context 'favourites' do
      it { should be_able_to :crud, create(:favourite, user: user) }
      it { should_not be_able_to :crud, create(:favourite, user: another_user) }
    end
  end

  context 'moderators' do
    let!(:user) { create(:moderator_user) }

    it { should be_able_to :manage, Wallpaper.new }
  end

  context 'admins' do
    let!(:user) { create(:admin_user) }
  end

  context 'developers' do
    let!(:user) { create(:developer_user) }
  end
end