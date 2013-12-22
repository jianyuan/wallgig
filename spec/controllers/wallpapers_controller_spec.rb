require 'spec_helper'

describe WallpapersController do
  describe 'GET #show' do
    let(:wallpaper) { FactoryGirl.create :wallpaper }

    it 'succeeds' do
      get :show, id: wallpaper.id
      response.should be_success
    end
  end

  describe 'POST #create' do
    it 'redirects when not signed in' do
      post :create
      response.should redirect_to new_user_session_path
    end

    describe 'when signed in' do
      let(:user) { FactoryGirl.create :user }
      before { sign_in user }
      let(:new_wallpaper) { FactoryGirl.create :wallpaper, user: user }
    end
  end

  describe 'PATCH #update' do
    let(:user)             { FactoryGirl.create :user }
    let(:my_wallpaper)     { FactoryGirl.create :wallpaper, user: user }
    let(:not_my_wallpaper) { FactoryGirl.create :wallpaper }

    it 'redirects when not signed in' do
      patch :update, id: not_my_wallpaper.id
      response.should redirect_to new_user_session_path
    end
  end
end