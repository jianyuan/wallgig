class ForumTopicsController < ApplicationController
  MODERATION_ACTIONS = [:pin, :unpin, :lock, :unlock, :hide, :unhide]

  before_action :authenticate_user!, only: [:new, :edit, :create, :update, :destroy].append(MODERATION_ACTIONS)
  before_action :set_and_authorize_parents_and_forum_topic_from_shallow!, except: [:index, :new, :create]
  before_action :set_and_authorize_parents_and_maybe_forum_topic!, only: [:index, :new, :create]

  before_action :ensure_can_moderate!, only: MODERATION_ACTIONS

  layout 'group'

  # GET /forum_topics
  # GET /forum_topics.json
  def index
    @forum_topics = @forum.topics.accessible_by(current_ability, :read).pinned_first
  end

  # GET /forum_topics/1
  # GET /forum_topics/1.json
  def show
  end

  # GET /forum_topics/new
  def new
    @forum_topic = @forum.topics.new
    @forum_topic.user = current_user
    authorize! :create, @forum_topic
  end

  # GET /forum_topics/1/edit
  def edit
    authorize! :update, @forum_topic
  end

  # POST /forum_topics
  # POST /forum_topics.json
  def create
    @forum_topic = @forum.topics.new(forum_topic_params)
    @forum_topic.user = current_user
    authorize! :create, @forum_topic

    respond_to do |format|
      if @forum_topic.save
        format.html { redirect_to @forum_topic, notice: 'Forum topic was successfully created.' }
        format.json { render action: 'show', status: :created, location: @forum_topic }
      else
        format.html { render action: 'new' }
        format.json { render json: @forum_topic.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /forum_topics/1
  # PATCH/PUT /forum_topics/1.json
  def update
    authorize! :update, @forum_topic

    respond_to do |format|
      if @forum_topic.update(forum_topic_params)
        format.html { redirect_to @forum_topic, notice: 'Forum topic was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @forum_topic.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /forum_topics/1
  # DELETE /forum_topics/1.json
  def destroy
    authorize! :destroy, @forum_topic

    @forum_topic.destroy
    respond_to do |format|
      format.html { redirect_to [@group, forum] }
      format.json { head :no_content }
    end
  end

  MODERATION_ACTIONS.each do |action|
    define_method action do
      @forum_topic.send("#{action.to_s}!")

      respond_to do |format|
        format.html { redirect_to @forum_topic, notice: "#{action.to_s.capitalize} action performed on topic." }
        format.json { head :no_content }
      end
    end
  end

  private

  def set_and_authorize_parents_and_forum_topic_from_shallow!
    @forum_topic = ForumTopic.find(params[:id])
    authorize! :read, @forum_topic

    @forum = @forum_topic.forum
    authorize! :read, @forum

    @group = @forum.group
    authorize! :read, @group
  end

  def set_and_authorize_parents_and_maybe_forum_topic!
    @group = Group.friendly.find(params[:group_id])
    authorize! :read, @group

    @forum = @group.forums.friendly.find(params[:forum_id])
    authorize! :read, @forum

    if params[:id].present?
      @forum_topic = @forum.topics.find(params[:id])
      authorize! :read, @forum_topic
    end
  end

  def forum_topic_params
    params.require(:forum_topic).permit(:title, :content)
  end

  def forum_topic_moderation_params
    params.require(:forum_topic).permit(:pinned, :locked, :hidden)
  end

  def ensure_can_moderate!
    authorize! :moderate, @forum_topic
  end
end
