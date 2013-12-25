class FavouritesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_wallpaper
  before_action :set_favourite, only: [:update, :destroy]

  layout false

  # POST /wallpapers/1/favourite
  # POST /wallpapers/1/favourite.json
  def create
    @favourite = @wallpaper.favourites.find_or_initialize_by(user: current_user)
    authorize! :create, @favourite

    if @favourite.save
      render partial: 'wallpapers/favourite_button', locals: { wallpaper: @wallpaper, favourite: @favourite }
    else
      render partial: 'wallpapers/favourite_button', locals: { wallpaper: @wallpaper, favourite: @favourite }, status: :unprocessable_entity
    end
  end

  # PATCH /wallpapers/1/favourite
  # PATCH /wallpapers/1/favourite.json
  def update
    authorize! :update, @favourite
    if favourite_params[:collection_id].present?
      @collection = Collection.find(favourite_params[:collection_id])
      authorize! :crud, @collection
      @favourite.collection = @collection
    else
      @favourite.collection = nil
    end

    if @favourite.save
      render partial: 'wallpapers/favourite_button', locals: { wallpaper: @wallpaper, favourite: @favourite }
    else
      render partial: 'wallpapers/favourite_button', locals: { wallpaper: @wallpaper, favourite: @favourite }, status: :unprocessable_entity
    end
  end

  # POST /wallpapers/1/favourite
  # POST /wallpapers/1/favourite.json
  def toggle
    @favourite = @wallpaper.favourites.find_or_initialize_by(user: current_user)
    if @favourite.persisted?
      authorize! :destroy, @favourite
      status = @favourite.destroy
    else
      authorize! :create, @favourite
      status = @favourite.save
    end

    if status
      render action: 'show'
    else
      render action: 'show', status: :unprocessable_entity
    end
  end

  # DELETE /wallpapers/1/favourite
  # DELETE /wallpapers/1/favourite.json
  def destroy
    authorize! :destroy, @favourite
    @favourite.destroy

    render partial: 'wallpapers/favourite_button', locals: { wallpaper: @wallpaper, favourite: nil }
  end

  private
    def set_wallpaper
      @wallpaper = Wallpaper.find(params[:wallpaper_id])
      authorize! :read, @wallpaper
    end

    def set_favourite
      @favourite = current_user.favourites.find_by(wallpaper: @wallpaper)
      authorize! :read, @favourite
    end

    def favourite_params
      params.require(:favourite).permit(:collection_id)
    end
end