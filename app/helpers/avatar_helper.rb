module AvatarHelper
  def avatars_for(user)
    Avatar.all
  end

  def show_avatar_item(item)
    "<img src='#{item.image_url}' alt='#{item.description}' mu-avatar-id='#{item.id}' class='mu-avatar-item'>".html_safe
  end
end
