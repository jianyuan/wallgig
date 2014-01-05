module SpecHelpers
  def signed_in_user
    user = FactoryGirl.create :user
    sign_in user
    user
  end
end