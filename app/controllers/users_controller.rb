class UsersController < ApplicationController
  before_action :set_user, only: [:show]

  # GET /users/1
  # GET /users/1.json
  def show
    @wallpapers = @user.wallpapers
                       .accessible_by(current_ability, :read)
                       .with_purity(:sfw)
                       .page(params[:page])

    if request.xhr?
      render layout: false, template: 'wallpapers/index'
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
      authorize! :read, @user
    end
end