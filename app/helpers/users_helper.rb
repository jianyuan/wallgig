module UsersHelper
  def user_tag(user)
    if user.has_role? :developer
      css_class = 'user-developer'
    elsif user.has_role? :admin
      css_class = 'user-admin'
    elsif user.has_role? :moderator
      css_class = 'user-moderator'
    else
      css_class = nil
    end
 
    link_to user.username, user, class: css_class
  end
end