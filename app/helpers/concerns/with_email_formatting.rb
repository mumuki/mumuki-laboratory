module WithEmailFormatting
  def assignment_help_email_body(assignment)
<<EOM
#{t :exercise}: #{assignment.exercise.name}

#{t :solution}:
#{assignment.solution}

#{t :status}: #{assignment.status}

See #{guide_by_slug_url(assignment.exercise.guide.organization_and_repository)}
EOM
  end

  def permissions_help_email_body(user)
<<EOM
#{t :want_permissions}: #{user.try(:uid)} - #{user.try(:email)}
EOM
  end
end
