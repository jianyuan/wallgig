class CommentsController < ApplicationController
  before_action :set_parent
  before_action :set_comment, only: [:destroy]
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

  # POST /parent/1/comments
  # POST /parent/1/comments.json
  def create
    @comment = @parent.comments.new(comment_params)
    @comment.user = current_user

    authorize! :create, @comment

    if @comment.save
      render partial: partial_name, locals: { comment: @comment }
    else
      render json: @comment.errors, status: :unprocessable_entity
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
    elsif params[:user_id].present?
      @parent = User.find_by(username: params[:user_id])
    end

    authorize! :read, @parent
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
