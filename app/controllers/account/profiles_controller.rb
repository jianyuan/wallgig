module Account
  class ProfilesController < ApplicationController
    before_action :authenticate_user!

    def remove_profile_cover
      current_profile.cover_wallpaper = nil
      current_profile.save

      respond_to do |format|
        format.html { redirect_to current_user, notice: 'Profile cover successfully removed.' }
        format.json { head :no_content }
      end
    end
  end
end