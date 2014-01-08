class Api::V1::FavouritesController < Api::V1::BaseController
  before_action :ensure_from_mashape!
  before_action :set_user

  def index
    @wallpapers = @user.favourite_wallpapers.page(params[:page]).decorate
    respond_with @wallpapers do |format|
      format.json { render template: 'api/v1/wallpapers/index' }
    end
  end

  private
    def set_user
      @user = User.find_by(username: params[:user_id])
      authorize! :read, @user
    end
end