class Api::V1::WallpapersController < Api::V1::BaseController
  before_action :set_wallpaper, only: [:show]

  def index
    if params[:user_id].present?
      @user = User.find_by(username: params[:user_id])
      authorize! :read, @user
      index_for @user.wallpapers.latest
    else
      index_for Wallpaper.latest
    end
  end

  def show
    @wallpaper = @wallpaper.decorate
    respond_with @wallpaper
  end

  def create
    @wallpaper = current_user.wallpapers.new(wallpaper_params)
    authorize! :create, @wallpaper

    respond_with @wallpaper do |format|
      if @wallpaper.save
        format.json { render action: 'show', status: :created, location: @wallpaper }
      else
        format.json { render json: @wallpaper.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    def index_for(scope)
      @wallpapers = scope.page(params[:page]).decorate
      respond_with @wallpapers do |format|
        format.json { render action: 'index' }
      end
    end

    def set_wallpaper
      @wallpaper = Wallpaper.find(params[:id])
      authorize! :read, @wallpaper
    end

    def wallpaper_params
      params.require(:wallpaper).permit(:purity, :image, :image_url, :tag_list, :image_gravity, :source)
    end
end