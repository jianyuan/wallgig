class FavouritesController < ApplicationController
  before_action :authenticate_user!, except: [:index]
  before_action :set_owner

  layout false, except: [:index]

  def index
    @wallpapers = set_owner.favourite_wallpapers
                           .accessible_by(current_ability, :read)
                           .page(params[:page])
    @wallpapers = WallpapersDecorator.new(@wallpapers, context: { user: current_user })

    if request.xhr?
      render partial: 'wallpapers/list', layout: false, locals: { wallpapers: @wallpapers }
    else
      render layout: 'user_profile'
    end
  end

  private

  def set_owner
    if params[:user_id].present?
      @owner = @user = User.find_by!(username: params[:user_id])
      authorize! :read, @owner
    end
  end
end
