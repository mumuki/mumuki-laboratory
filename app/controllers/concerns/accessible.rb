module Accessible
  def validate_subject_accessible!
    raise Mumuki::Laboratory::NotFoundError if subject && !subject.used_in?(Organization.current)
  end
end
