class CollectionsController < ApplicationController
  before_action :set_collection, only: [:show]

  # GET /collections/1
  # GET /collections/1.json
  def show
    @wallpapers = @collection.wallpapers.accessible_by(current_ability, :read).page(params[:page])
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