module MedalHelper
  def should_display_medal?(content, organization)
    content.medal.present? && organization.gamification_enabled?
  end

  def corollary_medal_for(content)
    medal_image_for content, 'inlay corollary'
  end

  def content_medal_for(content, user)
    medal_image_for content, "inlay content #{completion_class_for content, user}"
  end

  def content_medal_outline
    image_tag '/medal/outline.svg', class: "mu-medal outline content"
  end

  def corollary_medal_outline
    image_tag '/medal/outline.svg', class: "mu-medal outline corollary"
  end

  private

  def medal_image_for(content, clazz)
    image_tag content.medal.image_url, class: "mu-medal #{clazz}"
  end

  def completion_class_for(content, user)
    content.once_completed_for?(user, Organization.current) ? '' : 'unacquired'
  end
end
