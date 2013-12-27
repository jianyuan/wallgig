class Api::V1::BaseController < ApplicationController
  skip_before_action :verify_authenticity_token

  private
    def current_user
      super || (User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token)
    end
end