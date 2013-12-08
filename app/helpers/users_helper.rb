module UsersHelper
  def user_tag(user)
    link_to user.username, user
  end
end