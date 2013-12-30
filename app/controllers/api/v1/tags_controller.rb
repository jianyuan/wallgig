class Api::V1::TagsController < Api::V1::BaseController
  respond_to :json

  def index
    respond_with ActsAsTaggableOn::Tag.name_like(params[:query]).limit(20).pluck(:name)
  end
end