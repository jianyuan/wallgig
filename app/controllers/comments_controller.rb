class CommentsController < ApplicationController
  before_action :set_parent
  before_action :authenticate_user!, only: :create

  # GET /comments
  # GET /parent/1/comments
  # GET /parent/1/comments.json
  def index
    if parent.present?
      render partial: 'comment', collection: parent.comments.recent
    else
      @comments = Comment.includes(:commentable).latest.page(params[:page])
    end
  end

  # POST /parent/1/comments
  # POST /parent/1/comments.json
  def create
    @comment = parent.comments.new(comment_params)
    @comment.user = current_user

    authorize! :create, @comment

    if @comment.save
      render partial: 'comment', locals: { comment: @comment }
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end

  private
    def set_parent
      if params[:wallpaper_id].present?
        @wallpaper = Wallpaper.find(params[:wallpaper_id])
        authorize! :read, @wallpaper
      elsif params[:user_id].present?
        @user = User.find_by(username: params[:user_id])
        authorize! :read, @user
      end
    end

    def parent
      @wallpaper || @user
    end

    def comment_params
      params.require(:comment).permit(:comment)
    end
end