class UsersController < ApplicationController
  before_action :set_user, only: [:show]

  # GET /users/1
  # GET /users/1.json
  def show
    @wallpapers = @user.wallpapers
                       .accessible_by(current_ability, :read)
                       .page(params[:page])

    @favourite_wallpapers = @user.favourite_wallpapers
                                 .accessible_by(current_ability, :read)
                                 .limit(6)

    @collections = @user.collections
                        .accessible_by(current_ability, :read)
                        .ordered

    if request.xhr?
      render partial: 'wallpapers/list', layout: false, locals: { wallpapers: @wallpapers }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find_by!(username: params[:id])
      authorize! :read, @user
    end
end