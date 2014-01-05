require 'spec_helper'

describe WallpapersController do
  describe 'GET #index' do
    context 'when signed out' do
      it 'succeeds' do
        get :index
        expect(response).to be_success
      end
    end
  end

  describe 'GET #show' do
    let(:wallpaper) { FactoryGirl.create :wallpaper }

    context 'when signed out' do
      it 'succeeds' do
        get :show, id: wallpaper.id
        expect(response).to be_success
      end
    end
  end

  describe 'GET #new' do
    context 'when signed out' do
      it 'redirects to sign in page' do
        get :new
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'when signed in' do
      let!(:user) { signed_in_user }

      it 'succeeds' do
        get :new
        expect(response).to be_success
      end
    end
  end

  describe 'POST #create' do
    context 'when signed out' do
      it 'redirects to sign in page' do
        post :create
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'when signed in' do
      let(:user) { signed_in_user }
      let(:wallpaper) { FactoryGirl.create :wallpaper, user: user }
    end
  end

  describe 'PATCH #update' do
    let(:user)             { FactoryGirl.create :user }
    let(:my_wallpaper)     { FactoryGirl.create :wallpaper, user: user }
    let(:not_my_wallpaper) { FactoryGirl.create :wallpaper }

    context 'when signed out' do
      it 'redirects to sign in page' do
        patch :update, id: not_my_wallpaper.id
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:other_user) { FactoryGirl.create :user }
    let(:not_my_wallpaper) { FactoryGirl.create :wallpaper, user: other_user }

    context 'when signed out' do
      it 'redirects to sign in page' do
        delete :destroy, id: not_my_wallpaper.id
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'when signed in' do
      let!(:user) { signed_in_user }

      context 'not my wallpaper' do
        it 'raises an error' do
          expect { delete :destroy, id: not_my_wallpaper.id }.to raise_error CanCan::AccessDenied
        end
      end

      context 'my wallpaper' do
        let!(:my_wallpaper) { FactoryGirl.create :wallpaper, user: user }

        it 'destroys the wallpaper' do
          expect { delete :destroy, id: my_wallpaper.id }.to change(Wallpaper, :count).by(-1)
        end

        it 'redirects to index' do
          delete :destroy, id: my_wallpaper.id
          expect(response).to redirect_to wallpapers_path
        end
      end
    end
  end

  describe 'PATCH #update_purity' do
    let(:user) { FactoryGirl.create :user }
    let!(:wallpaper) { FactoryGirl.create :wallpaper, user: user, purity: 'sfw' }

    context 'when signed out' do
      it 'redirects to sign in page' do
        delete :destroy, id: wallpaper.id
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'when signed in' do
      before { sign_in user }

      context 'wallpaper with purity locked' do
        before do
          wallpaper.purity_locked = true
          wallpaper.save
        end

        it 'raises an error' do
          expect { patch :update_purity, id: wallpaper.id, purity: 'nsfw' }.to raise_error CanCan::AccessDenied
        end
      end

      context 'wallpaper with purity not locked' do
        before do
          wallpaper.purity_locked = false
          wallpaper.save
        end

        it 'changes the wallpaper purity' do
          patch :update_purity, id: wallpaper.id, purity: 'nsfw'
          wallpaper.reload
          expect(wallpaper.purity).to eq 'nsfw'
        end

        it 'redirects to the wallpaper' do
          patch :update_purity, id: wallpaper.id, purity: 'nsfw'
          expect(response). to redirect_to wallpaper
        end
      end
    end
  end
end