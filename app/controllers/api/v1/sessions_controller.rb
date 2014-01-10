class Api::V1::SessionsController < Api::V1::BaseController
  before_action :ensure_from_mashape!

  def create
    login    = params.require(:login)
    password = params.require(:password)

    user = User.find_for_database_authentication(login: login)
    if user.valid_password?(password)
      user.ensure_authentication_token!
      render json: { access_token: user.authentication_token }
    else
      render_json_error 'Incorrect login and/or password.', status: :unauthorized
    end
  end
end
