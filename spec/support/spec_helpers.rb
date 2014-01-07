RSpec.configure do |config|
  module Helpers
    def signed_in_user
      user = FactoryGirl.create(:user)
      sign_in user
      user
    end
  end

  config.include Helpers
end