class FavouritesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_wallpaper
  before_action :set_favourite, only: [:destroy]

  layout false

  # POST /wallpapers/1/favourites
  # POST /wallpapers/1/favourites.json
  def create
    @favourite = @wallpaper.favourites.find_or_initialize_by(user: current_user)

    if @favourite.save
      render partial: 'wallpapers/favourite_button', locals: { wallpaper: @wallpaper }
    else
      render partial: 'wallpapers/favourite_button', locals: { wallpaper: @wallpaper }, status: :unprocessable_entity
    end
  end

  # DELETE /wallpapers/1/favourites/1
  # DELETE /wallpapers/1/favourites/1.json
  def destroy
    @favourite.destroy

    render partial: 'wallpapers/favourite_button', locals: { wallpaper: @wallpaper }
  end

  private
    def set_wallpaper
      @wallpaper = Wallpaper.find(params[:wallpaper_id])
      authorize! :read, @wallpaper
    end

    def set_favourite
      @favourite = @wallpaper.favourites.find(params[:id])
      authorize! :crud, @favourite
    end
end