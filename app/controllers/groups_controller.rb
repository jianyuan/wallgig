class GroupsController < ApplicationController
  before_action :set_group, only: [:show, :edit, :update, :destroy, :apps, :update_apps]
  before_action :authenticate_user!, only: [:new, :edit, :create, :update, :destroy]

  layout 'group', except: :index

  # GET /groups
  # GET /groups.json
  def index
    @groups = Group.unofficial
    @official_groups = Group.official
  end

  # GET /groups/1
  # GET /groups/1.json
  def show
  end

  # GET /groups/new
  def new
    @group = current_user.owned_groups.new
    authorize! :create, @group
  end

  # GET /groups/1/edit
  def edit
    authorize! :update, @group
  end

  # POST /groups
  # POST /groups.json
  def create
    @group = current_user.owned_groups.new(group_params)
    authorize! :create, @group

    respond_to do |format|
      if @group.save
        format.html { redirect_to @group, notice: 'Group was successfully created.' }
        format.json { render action: 'show', status: :created, location: @group }
      else
        format.html { render action: 'new' }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /groups/1
  # PATCH/PUT /groups/1.json
  def update
    authorize! :update, @group

    respond_to do |format|
      if @group.update(group_params)
        format.html { redirect_to @group, notice: 'Group was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /groups/1
  # DELETE /groups/1.json
  def destroy
    authorize! :destroy, @group

    @group.destroy
    respond_to do |format|
      format.html { redirect_to groups_url }
      format.json { head :no_content }
    end
  end

  def apps
    authorize! :update, @group
  end

  def update_apps
    authorize! :update, @group

    respond_to do |format|
      if @group.update!(update_group_apps_params)
        format.html { redirect_to apps_group_url(@group), notice: 'Group apps was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'apps' }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def set_group
    @group = Group.friendly.find(params[:id])
    authorize! :read, @group
  end

  def group_params
    params.require(:group).permit(:name, :tagline, :description, :public, :admin_title, :moderator_title, :member_title)
  end

  def update_group_apps_params
    params.require(:group).permit(:has_forums)
  end
end
