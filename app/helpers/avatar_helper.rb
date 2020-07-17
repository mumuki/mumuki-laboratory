require 'pry'

module AvatarHelper
  def avatars_for(user, organization)
    avatars = target_avatars_for(organization)
    avatars << user.avatar if exists_and_not_in?(user.avatar, avatars)

    avatars
    end

  def show_avatar_item(item)
    "<img src='#{item.image_url}' alt='#{item.description}' mu-avatar-id='#{item.id}' class='mu-avatar-item'>".html_safe
  end

  private

  def target_avatars_for(organization)
    Avatar.select { |avatar| avatar.target == organization.target }
  end

  def exists_and_not_in?(avatar, avatars)
    avatar && (!avatar.in? avatars)
  end
end
