module EmailHelper
  def assignment_help_email_body(assignment)
<<EOM
#{t :exercise}: #{assignment.exercise.name}

#{t :solution}:
#{assignment.solution}

#{t :status}: #{assignment.status}

See #{exercise_by_slug_url(assignment.exercise.slug_parts)}
EOM
  end

  def permissions_help_email_body(user)
<<EOM
#{t :want_permissions}: #{user.try(:uid)} - #{user.try(:email)}
EOM
  end
end
