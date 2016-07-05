class AutomatedEvaluation < Evaluation
  def evaluate!
    submission.evaluate_against! assignment.exercise
  end
end