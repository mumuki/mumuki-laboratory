module WithSolutionEmailFormatting
  def assignment_help_email_body(assignment)
<<EOM
#{t :exercise}: #{assignment.exercise.name}

#{t :solution}:
#{assignment.solution}

#{t :status}: #{assignment.status}

See #{guide_url(assignment.exercise.guide.org_and_repo)}
EOM
  end
end