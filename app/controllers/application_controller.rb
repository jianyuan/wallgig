class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?

  helper UsersHelper
  helper_method :last_deploy_time

  rescue_from CanCan::AccessDenied do |e|
    respond_to do |format|
      format.html { redirect_to root_url, status: :unauthorized, alert: e.message }
      format.json { head :unauthorized }
    end
  end

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
end
