module AvatarHelper
  def avatars_for(user)
    (Avatar.with_current_audience_for(user) + user.acquired_medals + [user.avatar]).compact.uniq
  end

  def locked_avatars_for(user)
    user.unacquired_medals.compact.uniq
  end

  def show_locked_avatar_item(item)
    show_avatar_item(item, class: 'mu-avatar-item mu-locked')
  end

  def show_avatar_item(item, **options)
    avatar_image(item.image_url, alt: item.description, 'mu-avatar-id': item.id, class: 'mu-avatar-item', type: item.class.name, **options)
  end
end
