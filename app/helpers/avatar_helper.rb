module AvatarHelper
  def avatars_for(user)
    (Avatar.with_current_audience_for(user) + [user.avatar]).compact.uniq
  end

  def show_avatar_item(item)
    avatar_image(item.image_url, alt: item.description, 'mu-avatar-id': item.id, class: 'mu-avatar-item')
  end
end
