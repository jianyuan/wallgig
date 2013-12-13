class SessionsController < Devise::SessionsController
  # POST /resource/sign_in
  # def create
  #   self.resource = warden.authenticate!(auth_options)
  #   set_flash_message(:notice, :signed_in) if is_flashing_format?
  #   sign_in(resource_name, resource)

  #   if resource_name == :user && resource.discourse_user.present?
  #     cookies.permanent[:_t] = {
  #       value: resource.discourse_user.new_auth_token,
  #       domain: :all,
  #       httponly: true
  #     }
  #   end

  #   yield resource if block_given?
  #   respond_with resource, :location => after_sign_in_path_for(resource)
  # end
end