module Account
  class CollectionsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_collection, only: [:show, :edit, :update, :destroy]

    # GET /collections
    # GET /collections.json
    def index
      @collections = current_user.collections
    end

    # GET /collections/1
    # GET /collections/1.json
    def show
    end

    # GET /collections/new
    def new
      @collection = current_user.collections.new
    end

    # GET /collections/1/edit
    def edit
    end

    # POST /collections
    # POST /collections.json
    def create
      @collection = current_user.collections.new(collection_params)

      respond_to do |format|
        if @collection.save
          format.html { redirect_to account_collections_url, notice: 'Collection was successfully created.' }
          format.json { render action: 'show', status: :created, location: @collection }
        else
          format.html { render action: 'new' }
          format.json { render json: @collection.errors, status: :unprocessable_entity }
        end
      end
    end

    # PATCH/PUT /collections/1
    # PATCH/PUT /collections/1.json
    def update
      respond_to do |format|
        if @collection.update(collection_params)
          format.html { redirect_to account_collections_url, notice: 'Collection was successfully updated.' }
          format.json { head :no_content }
        else
          format.html { render action: 'edit' }
          format.json { render json: @collection.errors, status: :unprocessable_entity }
        end
      end
    end

    # DELETE /collections/1
    # DELETE /collections/1.json
    def destroy
      @collection.destroy
      respond_to do |format|
        format.html { redirect_to account_collections_url }
        format.json { head :no_content }
      end
    end

    private
      def set_collection
        @collection = current_user.collections.find(params[:id])
      end

      # Never trust parameters from the scary internet, only allow the white list through.
      def collection_params
        params.require(:collection).permit(:name, :public)
      end
  end
end