class Api::V1::BaseController < ApplicationController
  skip_before_action :verify_authenticity_token
  respond_to :json

  rescue_from ActionController::ParameterMissing do |exception|
    build_error_response(exception.message, :unprocessable_entity)
  end

  rescue_from ActiveRecord::RecordNotFound do |exception|
    build_error_response(exception.message, :not_found)
  end

  private

  def current_user
    super || (User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token)
  end

  def ensure_from_mashape!
    head :unauthorized if Rails.env.production? && request.headers['X-Mashape-Proxy-Secret'] != ENV['MASHAPE_PROXY_SECRET']
  end

  def authenticate_user_from_token!
    user_token = params.require(:user_token)
    user = User.find_by(authentication_token: user_token)
    raise AccessDenied if user.blank?
    sign_in user, store: false
  end

  def build_error_response(message, status)
    respond_to do |format|
      format.json { render_json_error(message, status: status) }
    end
  end

  def render_json_error(message, status: :unprocessable_entity)
    if message.is_a?(ActiveRecord::Base)
      message = message.errors.full_messages.to_sentence
    end
    response = { error: { message: message } }
    render json: response, status: status
  end
end