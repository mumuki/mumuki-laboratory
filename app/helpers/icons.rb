module Icons

  def status_icon(with_status)
    fa_icon *icon_for_status(with_status.status)
  end

  def exercise_status_icon(exercise)
    link_to exercise_status_fa_icon(exercise),
            exercise_submissions_path(exercise) if current_user?
  end

  def language_icon(language, options={})
    options = {alt: language.name, height: 16}.merge(options)
    link_to image_tag(language.image_url, options), exercises_path(q: language.name)
  end

  private

  def exercise_status_fa_icon(exercise)
    fa_icon(*icon_for_status(exercise.status_for(current_user)))
  end

  def icon_for_status(status)
    case status.to_s
      when 'passed' then ['check', class: 'text-success']
      when 'failed' then ['times', class: 'text-danger']
      when 'running' then ['circle', class: 'text-warning']
      when 'pending' then ['clock-o', class: 'text-info']
      when 'unknown' then ['circle', class: 'text-muted']
      else raise "Unknown status #{status}"
    end
  end
end
