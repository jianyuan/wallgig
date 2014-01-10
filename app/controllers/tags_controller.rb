require_dependency Rails.root.join('app/models/extensions/acts_as_taggable_on_tag').to_s

class TagsController < ApplicationController
  before_action :set_tag, only: [:show]

  def index
    render json: ActsAsTaggableOn::Tag.all
  end

  def show

  end

  private

  def set_tag
    @tag = ActsAsTaggableOn::Tag.friendly.find(params[:id])
  end
end
