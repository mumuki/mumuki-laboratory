module WithSolutionEmailFormatting
  def assignment_help_email_body(assignment)
    "#{t :exercise}:\n#{assignment.exercise.name}\n\n#{t :solution}:\n#{assignment.solution}\n\n#{t :status}:\n#{assignment.status}"
  end
end