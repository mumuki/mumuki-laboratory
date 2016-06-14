module Accessibility
  def validate_subject_accessible!
    raise Exceptions::NotFoundError if subject && !subject.used_in?(Organization.current)
  end
end
