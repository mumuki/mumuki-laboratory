module MedalHelper
  def corollary_medal_for(content)
    image_tag content.medal.image_url, class: 'mu-medal corollary'
  end

  def content_medal_for(content, user)
    image_tag content.medal.image_url, class: "mu-medal content #{completion_class_for content, user}"
  end

  private

  def completion_class_for(content, user)
    content.once_completed_for?(user, Organization.current) ? '' : 'unacquired'
  end
end
