module MedalHelper
  def should_display_medal?(content, organization)
    content.medal.present? && organization.gamification_enabled?
  end

  def content_medal_for(content, user)
    completion = completion_class_for content, user
    "#{content_medal_outline completion} #{content_medal_inlay_for(content, completion)}".html_safe
  end

  def corollary_medal_for(content)
    "#{corollary_medal_outline} #{corollary_medal_inlay_for(content)}".html_safe
  end

  private

  def content_medal_inlay_for(content, completion)
    inlay_image_for content, "inlay content #{completion}"
  end

  def corollary_medal_inlay_for(content)
    inlay_image_for content, 'inlay corollary'
  end

  def content_medal_outline(completion)
    outline_image "content #{completion}"
  end

  def corollary_medal_outline
    outline_image "corollary"
  end

  def inlay_image_for(content, clazz)
    image_tag content.medal.image_url, class: "mu-medal #{clazz}"
  end

  def outline_image(clazz)
    image_tag '/medal/outline.svg', class: "mu-medal outline #{clazz}"
  end

  def completion_class_for(content, user)
    content.once_completed_for?(user, Organization.current) ? '' : 'unacquired'
  end
end
