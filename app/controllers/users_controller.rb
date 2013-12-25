class UsersController < ApplicationController
  before_action :set_user, only: [:show]

  # GET /users/1
  # GET /users/1.json
  def show
    @wallpapers = @user.wallpapers
                       .accessible_by(current_ability, :index)
                       .limit(6)

    @favourite_wallpapers = @user.favourite_wallpapers
                                 .accessible_by(current_ability, :index)
                                 .limit(6)

    @collections = @user.collections
                        .accessible_by(current_ability, :index)
                        .includes(:user, :wallpapers)
                        .where({ wallpapers: { purity: 'sfw' }})
                        .where.not({ wallpapers: { id: nil } })
                        .ordered

    # OPTIMIZE
    if user_signed_in?
      @current_user_favourites = current_user.favourites.where(wallpaper_id: @wallpapers.map(&:id) + @favourite_wallpapers.map(&:id)).group(:wallpaper_id).size
    else
      @current_user_favourites = {}
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find_by!(username: params[:id])
      authorize! :read, @user
    end
end