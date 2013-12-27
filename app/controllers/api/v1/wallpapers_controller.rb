class Api::V1::WallpapersController < Api::V1::BaseController
  doorkeeper_for :all
  respond_to :json

  def create
    @wallpaper = current_user.wallpapers.new(wallpaper_params)
    authorize! :create, @wallpaper
    puts @wallpaper
    if @wallpaper.save
      respond_with @wallpaper, status: :created
    else
      respond_with @wallpaper, status: :unprocessable_entity
    end
  end

  private
    def wallpaper_params
      params.require(:wallpaper).permit(:purity, :image, :image_url, :tag_list, :image_gravity, :source)
    end
end