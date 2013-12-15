class CollectionsController < ApplicationController
  before_action :set_collection, only: [:show]
  impressionist actions: [:show]

  # GET /collections/1
  # GET /collections/1.json
  def show
    @wallpapers = @collection.wallpapers.accessible_by(current_ability, :index)
                                        .page(params[:page])

    if request.xhr?
      render partial: 'wallpapers/list', layout: false, locals: { wallpapers: @wallpapers }
    end
  end

  private
    def set_collection
      @collection = Collection.find(params[:id])
      authorize! :read, @collection
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def collection_params
      params.require(:collection).permit(:name, :public)
    end
end