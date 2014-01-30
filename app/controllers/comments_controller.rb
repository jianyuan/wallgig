class CommentsController < ApplicationController
  before_action :set_parent
  before_action :set_comment, only: [:edit, :update, :destroy]
  before_action :authenticate_user!, only: :create

  # GET /comments
  # GET /parent/1/comments
  # GET /parent/1/comments.json
  def index
    if @parent.present?
      render partial: partial_name, collection: @parent.comments.recent, as: :comment
    else
      @comments = Comment.includes(:commentable).latest.page(params[:page])
    end
  end

  def edit
    
  end

  def update

  end

  # POST /parent/1/comments
  # POST /parent/1/comments.json
  def create
    @comment = @parent.comments.new(comment_params)
    @comment.user = current_user

    authorize! :create, @comment

    if @comment.save
      if @parent.is_a?(ForumTopic)
        redirect_to @parent, notice: 'Comment was successfully created.'
      else
        render partial: partial_name, locals: { comment: @comment }
      end
    else
      render json: @comment.errors.full_messages, status: :unprocessable_entity
    end
  end

  def destroy
    authorize! :destroy, @comment
    @comment.destroy

    respond_to do |format|
      format.html { redirect_to @comment.commentable, notice: 'Comment was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def set_parent
    if params[:wallpaper_id].present?
      @parent = Wallpaper.find(params[:wallpaper_id])
      authorize! :read, @parent
    elsif params[:user_id].present?
      @parent = User.find_by(username: params[:user_id])
      authorize! :read, @parent
    elsif params[:forum_topic_id].present?
      @parent = ForumTopic.find(params[:forum_topic_id])
      authorize! :read, @parent
      authorize! :reply, @parent
    end
  end

  def set_comment
    @comment = Comment.find(params[:id])
    authorize! :read, @comment
  end

  def comment_params
    params.require(:comment).permit(:comment)
  end

  def partial_name
    if @parent.is_a?(Wallpaper)
      'wallpaper_comment'
    else
      'comment'
    end
  end
end
