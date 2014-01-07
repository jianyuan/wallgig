class FavouritesController < ApplicationController
  before_action :authenticate_user!, except: [:index]
  before_action :set_parent
  before_action :set_favourite, only: [:update, :destroy]

  layout false, except: [:index]

  # GET /users/1/favourites
  def index
    @wallpapers = @user.favourite_wallpapers
                       .accessible_by(current_ability, :read)
                       .page(params[:page])
    @wallpapers = WallpapersDecorator.new(@wallpapers, context: { user: current_user })

    if request.xhr?
      render partial: 'wallpapers/list', layout: false, locals: { wallpapers: @wallpapers }
    else
      render layout: 'user_profile'
    end
  end

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
    def set_parent
      if params[:wallpaper_id].present?
        @wallpaper = Wallpaper.find(params[:wallpaper_id])
        authorize! :read, @wallpaper
      elsif params[:user_id].present?
        @user = User.find_by(username: params[:user_id])
        authorize! :read, @user
      end
    end

    def parent
      @wallpaper || @user
    end

    def set_favourite
      @favourite = current_user.favourites.find_by(wallpaper: @wallpaper)
      authorize! :read, @favourite
    end

    def favourite_params
      params.require(:favourite).permit(:collection_id)
    end
end
