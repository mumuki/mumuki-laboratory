module EmailHelper
  def assignment_help_email_body(assignment)
<<EOM
#{t :exercise}: #{assignment.exercise.name}

#{t :solution}:
#{assignment.solution}

#{t :status}: #{assignment.status}

See #{transparent_exercise_url(assignment.exercise.transparent_params)}
EOM
  end

  def permissions_help_email_body(user, organization)
<<EOM
#{t :want_permissions} #{organization.name}: #{user.try(:uid)} - #{user.try(:email)}
EOM
  end
end
