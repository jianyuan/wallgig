class WallpapersController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_wallpaper, only: [:show, :edit, :update, :destroy, :update_purity, :history]
  impressionist actions: [:show]

  helper_method :search_params

  # GET /wallpapers
  # GET /wallpapers.json
  def index
    search_options = search_params

    if search_options[:order] == 'random'
      search_options[:random_seed] = session[:random_seed]
      search_options[:random_seed] = nil if search_options[:page].to_i <= 1
      search_options[:random_seed] ||= Time.now.to_i
      session[:random_seed] = search_options[:random_seed]
    end

    @wallpapers = WallpaperSearch.new(search_options).wallpapers

    if request.xhr?
      render partial: 'list', layout: false, locals: { wallpapers: @wallpapers }
    end
  end

  # GET /wallpapers/1
  # GET /wallpapers/1.json
  def show
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
      if @wallpaper.update(update_wallpaper_params)
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
    authorize! :update_purity, @wallpaper
    @wallpaper.purity = params[:purity]
    @wallpaper.save
  end

  # GET /wallpapers/1/history
  def history
  end

  # def elasticsearch
  #   query = Hash.new({})

  #   if params[:color].present? && (color = Color::RGB.from_html(params[:color]) rescue false)
  #     threshold = params[:threshold].to_i || 1
  #     # query[:function_score] = {
  #     #   boost_mode: 'replace',
  #     #   filter: {
  #     #     range: {
  #     #       # :'colors.percentage' => {
  #     #       #   gte: 0.5
  #     #       # }
  #     #       # :'colors.red' => {
  #     #       #   gte: color.red - threshold,
  #     #       #   lte: color.red + threshold
  #     #       # },
  #     #       # :'colors.green' => {
  #     #       #   gte: color.green - threshold,
  #     #       #   lte: color.green + threshold
  #     #       # },
  #     #       # :'colors.blue' => {
  #     #       #   gte: color.blue - threshold,
  #     #       #   lte: color.blue + threshold
  #     #       # }
  #     #       :'primary_color.red' => {
  #     #         gte: color.red - threshold,
  #     #         lte: color.red + threshold
  #     #       },
  #     #       :'primary_color.green' => {
  #     #         gte: color.green - threshold,
  #     #         lte: color.green + threshold
  #     #       },
  #     #       :'primary_color.blue' => {
  #     #         gte: color.blue - threshold,
  #     #         lte: color.blue + threshold
  #     #       }
  #     #     }
  #     #   },
  #     #   script_score: {
  #     #     params: {
  #     #       red: color.red,
  #     #       green: color.green,
  #     #       blue: color.blue
  #     #     },
  #     #     script: "-1 * (abs(doc['primary_color.red'].value - red) + abs(doc['primary_color.green'].value - green) + abs(doc['primary_color.blue'].value - blue))"
  #     #     # script: "-((abs(doc['colors.red'].value - red) + abs(doc['colors.green'].value - green) + abs(doc['colors.blue'].value - blue))) * (1 - doc['colors.percentage'].value)"
  #     #   }
  #     # }

  #     query[:function_score] = {
  #       query: {
  #         bool: {
  #           must: [
  #             {
  #               fuzzy: {
  #                 :'colors.red' => {
  #                   value: color.red.to_i,
  #                   min_similarity: threshold
  #                 }
  #               },
  #               fuzzy: {
  #                 :'colors.green' => {
  #                   value: color.green.to_i,
  #                   min_similarity: threshold
  #                 }
  #               },
  #               fuzzy: {
  #                 :'colors.blue' => {
  #                   value: color.blue.to_i,
  #                   min_similarity: threshold
  #                 }
  #               }
  #             }
  #           ]
  #         }
  #       },
  #       # boost_mode: 'replace',
  #       # filter: {
  #       #   and: {
  #       #     filters: [
  #       #       {
  #       #         range: {
  #       #           :'colors.red' => {
  #       #             gte: color.red - threshold,
  #       #             lte: color.red + threshold
  #       #           }
  #       #         }
  #       #       },
  #       #       {
  #       #         range: {
  #       #           :'colors.green' => {
  #       #             gte: color.green - threshold,
  #       #             lte: color.green + threshold
  #       #           }
  #       #         }
  #       #       },
  #       #       {
  #       #         range: {
  #       #           :'colors.blue' => {
  #       #             gte: color.blue - threshold,
  #       #             lte: color.blue + threshold
  #       #           }
  #       #         }
  #       #       }
  #       #     ]
  #       #   }
  #       # },
  #       script_score: {
  #         params: {
  #           red: color.red,
  #           green: color.green,
  #           blue: color.blue
  #         },
  #         script: "-1 * (abs(doc['colors.red'].value - red) + abs(doc['colors.green'].value - green) + abs(doc['colors.blue'].value - blue)) * (1 - doc['colors.percentage'].value)"
  #       }
  #     }
  #   else
  #     query[:match_all] = {}
  #   end
  #   # @wallpapers = Wallpaper.tire.search nil, query: query
  #   # @query = Tire.search(Wallpaper.tire.index.name, payload: { size: 200, query: query }, load: Rails.env.production?)
  #   # @results = @query.results
  #   @wallpapers = Wallpaper.search(params)
  # end

  private
    def set_wallpaper
      @wallpaper = Wallpaper.find(params[:id])
      authorize! :read, @wallpaper
    end

    def wallpaper_params
      params.require(:wallpaper).permit(:purity, :image, :tag_list, :image_gravity, :source)
    end

    def update_wallpaper_params_with_purity
      params.require(:wallpaper).permit(:tag_list, :image_gravity, :source, :purity)
    end

    def update_wallpaper_params_without_purity
      update_wallpaper_params_with_purity.tap { |p| p.delete(:purity) }
    end

    def update_wallpaper_params
      if can? :update_purity, @wallpaper
        update_wallpaper_params_with_purity
      else
        update_wallpaper_params_without_purity
      end
    end

    def search_params
      params.permit(:q, :page, :width, :height, :order, purity: [], tags: [], exclude_tags: [], colors: []).tap do |p|
        # Default values
        p[:order] ||= 'latest'
        p[:purity] ||= ['sfw']
      end
    end
end
