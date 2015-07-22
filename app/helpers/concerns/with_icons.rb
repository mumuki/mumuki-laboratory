module WithIcons
  #FIXME refactor names
  def status_icon(status_like)
    fa_icon *icon_for_status(Status.coerce(status_like))
  end

  def exercise_status_icon(exercise)
    link_to exercise_status_fa_icon(exercise),
            exercise_path(exercise) if current_user?
  end

  def language_icon(language, options={})
    options = {alt: language.name, height: 16, class: 'special-icon'}.merge(options)
    link_to image_tag(language.image_url, options), (options[:link_path] || guides_path(q: language.name))
  end

  private

  def exercise_status_fa_icon(exercise)
    fa_icon(*icon_for_status(exercise.status_for(current_user)))
  end

  def class_for_status(s)
    s.iconize[:class].to_s
  end

  def icon_type_for_status(s)
    s.iconize[:type].to_s
  end

  def icon_for_status(s)
    iconized = s.iconize
    [iconized[:type], class: "text-#{iconized[:class]} special-icon"]
  end

end
