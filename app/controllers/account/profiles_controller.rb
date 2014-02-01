module Account
  class ProfilesController < ApplicationController
    before_action :authenticate_user!
    before_action :set_profile

    def edit
    end

    def update
      update_params = profile_params
      update_params.merge!(title_and_color_params) if can? :update_title_and_color, @profile

      respond_to do |format|
        if @profile.update(update_params)
          format.html { redirect_to edit_account_profile_url, notice: 'Profile was successfully updated.' }
          format.json { head :no_content }
        else
          format.html { render action: 'edit' }
          format.json { render json: @profile.errors, status: :unprocessable_entity }
        end
      end
    end

    def remove_profile_cover
      @profile.cover_wallpaper = nil
      @profile.save

      respond_to do |format|
        format.html { redirect_to current_user, notice: 'Profile cover successfully removed.' }
        format.json { head :no_content }
      end
    end

    private

    def set_profile
      @profile = current_profile
    end

    def profile_params
      params.require(:user_profile).permit(:avatar)
    end

    def title_and_color_params
      params.require(:user_profile).permit(:title, :username_color_hex)
    end
  end
end