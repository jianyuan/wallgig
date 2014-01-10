class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?

  helper UsersHelper
  helper_method :last_deploy_time

  class AccessDenied < CanCan::AccessDenied; end

  rescue_from AccessDenied,         with: :access_denied_response
  rescue_from CanCan::AccessDenied, with: :access_denied_response

  protected

  def authenticate_admin_user!
    redirect_to new_user_session_path unless current_user.try(:admin?)
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:username, :email, :password, :password_confirmation) }
    devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:login, :password, :remember_me) }
  end

  def last_deploy_time
    @last_deploy_time ||= File.new(Rails.root.join('last_deploy')).atime rescue nil
  end

  private

  def access_denied_response(exception)
    respond_to do |format|
      format.html { redirect_to root_url, alert: exception.message, status: :unauthorized }
      format.json do
        response = {
          error: {
            message: exception.message
          }
        }
        render json: response, status: :unauthorized
      end
    end
  end
end
