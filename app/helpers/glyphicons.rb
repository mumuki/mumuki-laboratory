module Glyphicons

  def glyphicon(name)
    "<span class=\"glyphicon glyphicon-#{name}\"></span>".html_safe
  end

  def status_span(status)
    glyphicon(glyphicon_for_status(status))
  end

  #TODO may reuse colors and icons with submission statuses
  def glyphicon_for_exercise(exercise)
    return nil unless current_user?
    text_class =
        if !exercise.submitted_by?(current_user)
          'text-muted'
        elsif exercise.solved_by?(current_user)
          'text-success'
        else
          'text-danger'
        end
    "<span class=\"glyphicon glyphicon-certificate #{text_class}\" aria-hidden=\"true\"></span>".html_safe
  end

  private

  def glyphicon_for_status(status)
    case status.to_s
      when 'passed' then 'ok'
      when 'failed' then 'remove'
      when 'running' then 'time'
      when 'pending' then 'time'
      else raise "Unknown status #{status}"
    end
  end
end
