module Accessibility
  def validate_subject_accessible!
    render_not_found if subject && !subject.used_in?(Organization.current)
  end
end