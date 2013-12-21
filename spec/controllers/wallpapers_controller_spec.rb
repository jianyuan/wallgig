require 'spec_helper'

describe WallpapersController do
  context 'when signed out' do
    describe 'POST #create' do
      before { post :create }

      it { should redirect_to(new_user_session_path) }
    end
  end

  context 'a wallpaper' do
    let(:wallpaper) { FactoryGirl.create :wallpaper }

    describe 'PATCH #update' do
      before { patch :update, id: wallpaper.id }

      it { should redirect_to(new_user_session_path) }
    end
  end

  context 'when signed in' do
    let(:user) { FactoryGirl.create :user }
    before { sign_in user }
  end
end
