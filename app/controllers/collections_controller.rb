class CollectionsController < ApplicationController
  before_action :set_collection, only: [:show]
  before_action :set_user, if: -> { params[:user_id].present? } # TODO deprecate
  before_action :set_parent
  layout :resolve_layout
  impressionist actions: [:show]

  # GET /collections
  def index
    if @user.present?
      # Viewing user's collections. They are ordered.
      relation = @user.collections.ordered
    else
      relation = Collection.where({ wallpapers: { purity: 'sfw' }})
                           .where.not({ wallpapers: { id: nil } })
    end


    @collections = relation.includes(:user, :wallpapers)
                           .accessible_by(current_ability, :read)
                           .order('collections.updated_at desc')
                           .page(params[:page])

    if request.xhr?
      render partial: 'list', layout: false, locals: { collections: @collections }
    end
  end

  # GET /collections/1
  def show
    wallpapers = @collection.wallpapers
                            .accessible_by(current_ability, :read)
                            .latest
                            .page(params[:page])
    @wallpapers = WallpapersDecorator.new(wallpapers, context: { user: current_user })

    if request.xhr?
      render partial: 'wallpapers/list', layout: false, locals: { wallpapers: @wallpapers }
    end
  end

  private

  # TODO deprecate
  def set_user
    @user = User.find_by(username: params[:user_id])
    authorize! :read, @user
  end

  def set_parent
    if params[:user_id].present?
      @parent = User.find_by!(username: params[:user_id])
    elsif params[:group_id].present?
      @parent = @group = Group.friendly.find(params[:group_id])
    end
    authorize! :read, @parent if @parent.present?
  end

  def set_collection
    @collection = Collection.find(params[:id])
    authorize! :read, @collection
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def collection_params
    params.require(:collection).permit(:name, :public)
  end

  def resolve_layout
    if @parent.is_a?(User) || @user.present? # TODO deprecate
      'user_profile'
    elsif @parent.is_a?(Group)
      'group'
    else
      'application'
    end
  end

end
