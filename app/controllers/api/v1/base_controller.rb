class Api::V1::BaseController < ApplicationController
  skip_before_action :verify_authenticity_token
  respond_to :json

  rescue_from ActionController::ParameterMissing do |e|
    response = {
      errors: {
        e.param => 'param is required'
      }
    }
    respond_to do |format|
      format.json { render json: response, status: :unprocessable_entity }
    end
  end

  private
    def current_user
      super || (User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token)
    end

    def ensure_from_mashape!
      head :unauthorized unless request.headers['X-Mashape-Proxy-Secret'] == ENV['MASHAPE_PROXY_SECRET']
    end
end