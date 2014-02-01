module UsersHelper
  def link_to_user(user)
    link_to user.username, user, class: css_class_for(user)
  end

  def username_tag(user)
    content_tag :span, user.username, class: css_class_for(user)
  end

  def css_class_for(user)
    if user.developer?
      'user-developer'
    elsif user.admin?
      'user-admin'
    elsif user.moderator?
      'user-moderator'
    end
  end

  def role_name_for(user)
    if user.profile.title.present?
      user.profile.title
    elsif user.developer?
      'Developer'
    elsif user.admin?
      'Admin'
    elsif user.moderator?
      'Moderator'
    else
      'Member'
    end
  end

  def user_avatar_url(user, size = 200)
    avatar = user.profile.avatar
    if avatar.present?
      avatar.thumb("#{size}x#{size}#").url
    else
      gravatar_url(user, size)
    end
  end
end
