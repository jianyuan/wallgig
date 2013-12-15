module UsersHelper
  def link_to_user(user)
    link_to user.username, user, class: css_class_for(user)
  end

  def username_tag(user)
    content_tag :span, user.username, class: css_class_for(user)
  end

  def css_class_for(user)
    if user.has_role? :developer
      'user-developer'
    elsif user.has_role? :admin
      'user-admin'
    elsif user.has_role? :moderator
      'user-moderator'
    end
  end

  def role_name_for(user)
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