module MedalHelper
  def should_display_medal?(content, organization)
    content.medal.present? && organization.gamification_enabled?
  end

  def content_medal_for(content, user)
    medal_for content, 'content', completion_class_for(content, user)
  end

  def corollary_medal_for(content)
    medal_for content, 'corollary'
  end

  private

  def completion_class_for(content, user)
    content.once_completed_for?(user, Organization.current) ? '' : 'unacquired'
  end

  def medal_for(content, view, completion='')
    %Q{
      <div class="mu-medal #{completion}">
        #{outline_image(view)}
        #{inlay_image_for(content, view)}
      </div>
    }.html_safe
  end

  def outline_image(clazz)
    image_tag '/medal/outline.svg', class: "mu-medal outline #{clazz}"
  end

  def inlay_image_for(content, clazz)
    image_tag content.medal.image_url, class: "mu-medal inlay #{clazz}"
  end
end
