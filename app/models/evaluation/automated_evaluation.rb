class AutomatedEvaluation
  def evaluate!(assignment, submission)
    submission.evaluate_against! assignment
  end
end
