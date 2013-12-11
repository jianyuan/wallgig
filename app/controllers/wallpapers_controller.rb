class WallpapersController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_wallpaper, only: [:show, :edit, :update, :destroy, :update_purity]
  impressionist actions: [:show] # Increase view count

  # GET /wallpapers
  # GET /wallpapers.json
  def index
    query = Wallpaper.accessible_by(current_ability, :read)
                     .order(created_at: :desc)

    query = query.tagged_with(search_params[:tag]) if search_params[:tag].present?
    query = query.near_to_color(search_params[:color]) if search_params[:color].present?

    if search_params[:purity].present?
      query = query.with_purity(*search_params[:purity])
    else
      query = query.with_purity(:sfw)
    end
    
    @wallpapers = query.page(params[:page])

    @tags = Wallpaper.tag_counts_on(:tags).limit(20)

    if request.xhr?
      render partial: 'list', layout: false
    end
  end

  # GET /wallpapers/1
  # GET /wallpapers/1.json
  def show
    authorize! :read, @wallpaper
  end

  # GET /wallpapers/new
  def new
    @wallpaper = current_user.wallpapers.new
    authorize! :create, @wallpaper
  end

  # GET /wallpapers/1/edit
  def edit
    authorize! :update, @wallpaper
  end

  # POST /wallpapers
  # POST /wallpapers.json
  def create
    @wallpaper = current_user.wallpapers.new(wallpaper_params)
    authorize! :create, @wallpaper

    respond_to do |format|
      if @wallpaper.save
        format.html { redirect_to @wallpaper, notice: 'Wallpaper was successfully created.' }
        format.json { render action: 'show', status: :created, location: @wallpaper }
      else
        format.html { render action: 'new' }
        format.json { render json: @wallpaper.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /wallpapers/1
  # PATCH/PUT /wallpapers/1.json
  def update
    authorize! :update, @wallpaper
    respond_to do |format|
      if @wallpaper.update(wallpaper_params)
        format.html { redirect_to @wallpaper, notice: 'Wallpaper was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @wallpaper.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /wallpapers/1
  # DELETE /wallpapers/1.json
  def destroy
    authorize! :destroy, @wallpaper
    @wallpaper.destroy
    respond_to do |format|
      format.html { redirect_to wallpapers_url }
      format.json { head :no_content }
    end
  end

  # PATCH /wallpapers/1/update_purity.js
  def update_purity
    authorize! :update, @wallpaper
    @wallpaper.purity = params[:purity]
    @wallpaper.save
  end

  def elasticsearch
    # @wallpapers = Wallpaper.tire.search load: true do
    #   size 200
    #   # page params[:page] || 1
    #   query do
    #     boolean do
    #       # must { string 'purity:sfw' }
    #       # should { string 'width:1920' }
    #       # should { string 'height:1080' }
    #       # should { string 'tags:anime' }
    #     end
    #     function_score do
          
    #     end
    #   end
    #   # facet('current-tags', global: true) { terms :tags }
    #   # sort { by :created_at, 'asc' }
    # end
    query = Hash.new({})

    if params[:color].present? && (color = Color::RGB.from_html(params[:color]) rescue false)
      threshold = params[:threshold] || 1
      # query[:function_score] = {
      #   boost_mode: 'replace',
      #   filter: {
      #     range: {
      #       # :'colors.percentage' => {
      #       #   gte: 0.5
      #       # }
      #       # :'colors.red' => {
      #       #   gte: color.red - threshold,
      #       #   lte: color.red + threshold
      #       # },
      #       # :'colors.green' => {
      #       #   gte: color.green - threshold,
      #       #   lte: color.green + threshold
      #       # },
      #       # :'colors.blue' => {
      #       #   gte: color.blue - threshold,
      #       #   lte: color.blue + threshold
      #       # }
      #       :'primary_color.red' => {
      #         gte: color.red - threshold,
      #         lte: color.red + threshold
      #       },
      #       :'primary_color.green' => {
      #         gte: color.green - threshold,
      #         lte: color.green + threshold
      #       },
      #       :'primary_color.blue' => {
      #         gte: color.blue - threshold,
      #         lte: color.blue + threshold
      #       }
      #     }
      #   },
      #   script_score: {
      #     params: {
      #       red: color.red,
      #       green: color.green,
      #       blue: color.blue
      #     },
      #     script: "-1 * (abs(doc['primary_color.red'].value - red) + abs(doc['primary_color.green'].value - green) + abs(doc['primary_color.blue'].value - blue))"
      #     # script: "-((abs(doc['colors.red'].value - red) + abs(doc['colors.green'].value - green) + abs(doc['colors.blue'].value - blue))) * (1 - doc['colors.percentage'].value)"
      #   }
      # }

      query[:bool] = {
        :should => [
          {
            :fuzzy => {
              :'primary_color.red' => {
                :value => color.red.to_i
              }
            }
          }
        ]
      }
    else
      query[:match_all] = {}
    end
    # @wallpapers = Wallpaper.tire.search nil, query: query
    @query = Tire.search(Wallpaper.tire.index.name, payload: { size: 200, query: query }, load: Rails.env.production?)
    @results = @query.results
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_wallpaper
      @wallpaper = Wallpaper.find(params[:id])
      authorize! :read, @wallpaper
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def wallpaper_params
      params.require(:wallpaper).permit(:purity, :image, :tag_list)
    end

    def search_params
      params.permit(:tag, :color, purity: [])
    end
end
