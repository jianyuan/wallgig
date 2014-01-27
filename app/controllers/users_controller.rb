class UsersController < ApplicationController
  before_action :set_user, only: [:show]
  before_action :authenticate_user!, only: [:update_screen_resolution]

  impressionist actions: [:show]

  layout 'user_profile'

  # GET /users/1
  # GET /users/1.json
  def show
    wallpapers = @user.wallpapers
                       .accessible_by(current_ability, :read)
                       .latest
                       .limit(6)
    @wallpapers = WallpapersDecorator.new(wallpapers, context: { user: current_user })

    favourites = @user.favourites
                       .includes(:wallpaper)
                       .accessible_by(current_ability, :read)
                       .latest
                       .limit(10)
    @favourite_wallpapers = WallpapersDecorator.new(favourites.map(&:wallpaper), context: { user: current_user })

    # OPTIMIZE
    @collections = @user.collections
                        .includes(:wallpapers)
                        .accessible_by(current_ability, :read)
                        .where({ wallpapers: { purity: 'sfw' }})
                        .where.not({ wallpapers: { id: nil } })
                        .order('collections.updated_at DESC') # FIXME
                        .limit(6)
  end

  def update_screen_resolution
    width  = params.require(:width)
    height = params.require(:height)
    current_settings.update(screen_width: width, screen_height: height)

    respond_to do |format|
      format.html { redirect_to root_url }
      format.json { head :no_content }
    end
  end

  private

  def set_user
    @user = User.find_by!(username: params[:id])
    authorize! :read, @user
  end
end
