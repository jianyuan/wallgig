class GroupsController < ApplicationController
  before_action :set_group, only: [:show, :edit, :update, :destroy, :apps, :update_apps, :join, :leave]
  before_action :authenticate_user!, only: [:new, :edit, :create, :update, :destroy, :apps, :update_apps, :join, :leave]

  layout 'group', except: [:index, :new, :create]

  def index
    @groups = Group.unofficial
                   .accessible_by(current_ability, :read)
                   .page(params[:page])

    @order_by = params[:order]
    case @order_by
    when 'newest'
      @groups = @groups.newest
    when 'alphabetically'
      @groups = @groups.alphabetically
    else
      @groups = @groups.recently_active
    end

    @official_groups = Group.official.accessible_by(current_ability, :read).alphabetically
  end

  # GET /groups/1
  # GET /groups/1.json
  def show
    @officers = @group.users_groups.officers.includes(user: :profile)
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
      if @group.update(update_group_apps_params)
        format.html { redirect_to apps_group_url(@group), notice: 'Group apps was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'apps' }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  def join
    authorize! :join, @group

    respond_to do |format|
      if @group.add_member(current_user)
        format.html { redirect_to @group, notice: 'You have successfully joined this group.' }
        format.json { head :no_content }
      else
        format.html { render groups_url, alert: 'You cannot join this group.' }
        format.json { head :unprocessable_entity }
      end
    end
  end

  def leave
    authorize! :leave, @group
    @group.users_groups.find_by!(user_id: current_user.id).destroy

    respond_to do |format|
      format.html { redirect_to @group, notice: 'You have left the group.' }
      format.json { head :no_content }
    end
  end

  private

  def set_group
    @group = Group.friendly.find(params[:id])
    authorize! :read, @group
  end

  def group_params
    params.require(:group).permit(:name, :tagline, :description, :public, :admin_title, :moderator_title, :member_title, :access)
  end

  def update_group_apps_params
    params.require(:group).permit(:has_forums)
  end
end
