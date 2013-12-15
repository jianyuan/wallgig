module Account
  class CollectionsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_collection, only: [:show, :edit, :update, :destroy, :move_up, :move_down]

    # GET /account/collections
    # GET /account/collections.json
    def index
      @collections = current_user.collections.ordered
    end

    # GET /account/collections/1
    # GET /account/collections/1.json
    def show
    end

    # GET /account/collections/new
    def new
      @collection = current_user.collections.new
    end

    # GET /account/collections/1/edit
    def edit
    end

    # POST /account/collections
    # POST /account/collections.json
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

    # PATCH/PUT /account/collections/1
    # PATCH/PUT /account/collections/1.json
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

    # DELETE /account/collections/1
    # DELETE /account/collections/1.json
    def destroy
      @collection.destroy
      respond_to do |format|
        format.html { redirect_to account_collections_url }
        format.json { head :no_content }
      end
    end

    # PATCH/PUT /account/collections/1/move_up
    # PATCH/PUT /account/collections/1/move_up.json
    def move_up
      @collection.move_higher
      redirect_to account_collections_url, notice: 'Collection was successfully reordered.'
    end

    # PATCH/PUT /account/collections/1/move_down
    # PATCH/PUT /account/collections/1/move_down.json
    def move_down
      @collection.move_lower
      redirect_to account_collections_url, notice: 'Collection was successfully reordered.'
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