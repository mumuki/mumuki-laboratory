module IconsHelper
  #FIXME refactor names
  def status_icon(status_like)
    fa_icon *icon_for_status(status_like.to_assignment_status)
  end

  def fixed_fa_icon(name, options={})
    fa_icon name, options.merge(class: 'fa-fw fixed-icon')
  end

  def exercise_status_icon(exercise)
    link_to exercise_status_fa_icon(exercise),
            exercise_path(exercise) if current_user?
  end

  def language_icon(language)
    tag('span', class: "fa da da-#{language.devicon} lang-icon", alt: language.name)
  end

  private

  def status_fa_icon(status)
    fa_icon(*icon_for_status(status))
  end

  def exercise_status_fa_icon(exercise)
    status_fa_icon(exercise.status_for(current_user))
  end

  def discussion_status_fa_icon(discussion)
    status_fa_icon(discussion.status)
  end

  def icon_for_status(s)
    iconized = s.iconize
    [iconized[:type], class: "text-#{iconized[:class]} status-icon"]
  end

  def icon_for_read(read)
    tag('i', class: "fa fa-envelope#{read ? '-o' : ''}")
  end

end
