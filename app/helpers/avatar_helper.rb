module AvatarHelper
  def avatars_for(user)
    (Avatar.with_current_audience_for(user) + [user.avatar]).compact.uniq
  end

  def show_avatar_item(item)
    "<img src='#{item.image_url}' alt='#{item.description}' mu-avatar-id='#{item.id}' class='mu-avatar-item'>".html_safe
  end
end
