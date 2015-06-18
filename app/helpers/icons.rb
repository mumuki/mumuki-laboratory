module Icons

  def status_icon(with_status)
    fa_icon *icon_for_status( with_status.is_a?(Symbol) ? with_status : with_status.fine_status)
  end

  def exercise_status_icon(exercise)
    link_to exercise_status_fa_icon(exercise),
            exercise_submissions_path(exercise) if current_user?
  end

  def language_icon(language, options={})
    options = {alt: language.name, height: 16, class: 'special-icon'}.merge(options)
    link_to image_tag(language.image_url, options), (options[:link_path] || guides_path(q: language.name))
  end

  private

  def exercise_status_fa_icon(exercise)
    fa_icon(*icon_for_status(exercise.status_for(current_user)))
  end

  #FIXME refactor
  def class_for_status(status)
    case status.to_s
      when 'passed' then 'success'
      when 'passed_with_warnings' then 'warning'
      when 'failed' then 'danger'
      when 'running' then 'info'
      when 'pending' then 'info'
      when 'unknown' then 'muted'
      else raise "Unknown status #{status}"
    end
  end

  def icon_type_for_status(status)
    case status.to_s
      when 'passed' then 'check'
      when 'passed_with_warnings' then 'exclamation'
      when 'failed' then 'times'
      when 'running' then 'circle'
      when 'pending' then 'clock-o'
      when 'unknown' then 'circle'
      else raise "Unknown status #{status}"
    end
  end

  def icon_for_status(status)
    def i(icon, class_)
      [icon, class: "text-#{class_} special-icon"]
    end
    i icon_type_for_status(status), class_for_status(status)
  end

  def icon_for_follower following
    if following
      fa_icon(*icon_for_status("passed"))
    else
      fa_icon(*icon_for_status("failed"))
    end
  end

end
