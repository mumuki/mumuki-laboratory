module AvatarHelper
  def avatars_for(user)
    (Avatar.with_current_audience_for(user) + user.acquired_medals + [user.avatar]).compact.uniq
  end

  def show_avatar_item(item)
    avatar_image(item.image_url, alt: item.description, 'mu-avatar-id': item.id, class: 'mu-avatar-item', type: item.class.name)
  end
end
