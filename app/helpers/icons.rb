module Icons

  def status_span(status)
    fa_icon *icon_for_status(status)
  end

  def exercise_status_icon(exercise)
    fa_icon *icon_for_status(exercise.status_for(current_user)) if current_user?
  end

  private

  def icon_for_status(status)
    case status.to_s
      when 'passed' then ['check', class: 'text-success']
      when 'failed' then ['times', class: 'text-danger']
      when 'running' then ['circle', class: 'text-warning']
      when 'pending' then ['time', class: 'text-info']
      when 'unknown' then ['circle', class: 'text-muted']
      else raise "Unknown status #{status}"
    end
  end
end
