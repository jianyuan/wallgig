class CommentsController < ApplicationController
  before_action :set_parent
  before_action :authenticate_user!, only: :create

  def index
    render partial: 'comments/comment', collection: parent.comments.recent
  end

  def create
    @comment = parent.comments.new(comment_params)
    @comment.user = current_user

    authorize! :create, @comment

    if @comment.save
      render partial: 'comments/comment', locals: { comment: @comment }
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