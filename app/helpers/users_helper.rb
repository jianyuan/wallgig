module UsersHelper
  def user_tag(user)
    link_to user.username, user, class: css_class_for_user(user)
  end

  def css_class_for_user(user)
    if user.has_role? :developer
      'user-developer'
    elsif user.has_role? :admin
      'user-admin'
    elsif user.has_role? :moderator
      'user-moderator'
    end
  end

  def role_name_for_user(user)
    if user.has_role? :developer
      'Developer'
    elsif user.has_role? :admin
      'Admin'
    elsif user.has_role? :moderator
      'Moderator'
    else
      'Member'
    end
  end
end