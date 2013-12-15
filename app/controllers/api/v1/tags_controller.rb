class Api::V1::TagsController < Api::V1::BaseController
  respond_to :json

  def index
    respond_with Tag.pluck :name
  end
end