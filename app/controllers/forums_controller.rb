class ForumsController < ApplicationController
  before_action :set_group, except: [:official_index]
  before_action :set_forum, only: [:show, :edit, :update, :destroy]

  layout 'group', except: [:official_index]

  # GET /forums
  # GET /forums.json
  def index
    @forums = @group.forums.accessible_by(current_ability, :read)
  end

  def official_index
    @groups = Group.official.accessible_by(current_ability, :read)
                   .includes(:forums)
  end

  # GET /forums/1
  # GET /forums/1.json
  def show
    @topics = @forum.topics.accessible_by(current_ability, :read).pinned_first.latest
  end

  # GET /forums/new
  def new
    @forum = @group.forums.new
    authorize! :create, @forum
  end

  # GET /forums/1/edit
  def edit
    authorize! :update, @forum
  end

  # POST /forums
  # POST /forums.json
  def create
    @forum = @group.forums.new(forum_params)
    authorize! :create, @forum

    respond_to do |format|
      if @forum.save
        format.html { redirect_to [@group, @forum], notice: 'Forum was successfully created.' }
        format.json { render action: 'show', status: :created, location: [@group, @forum] }
      else
        format.html { render action: 'new' }
        format.json { render json: @forum.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /forums/1
  # PATCH/PUT /forums/1.json
  def update
    authorize! :update, @forum

    respond_to do |format|
      if @forum.update(forum_params)
        format.html { redirect_to [@group, @forum], notice: 'Forum was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @forum.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /forums/1
  # DELETE /forums/1.json
  def destroy
    authorize! :destroy, @forum

    @forum.destroy
    respond_to do |format|
      format.html { redirect_to group_forums_url(@group) }
      format.json { head :no_content }
    end
  end

  private

  def set_group
    @group = Group.friendly.find(params[:group_id])
    authorize! :read, @group
  end

  def set_forum
    @forum = @group.forums.friendly.find(params[:id])
    authorize! :read, @forum
  end

  def forum_params
    params.require(:forum).permit(:name, :slug, :description)
  end
end
