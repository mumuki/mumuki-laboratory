class Question < Submission
  def setup_assignment!(assignment)
    assignment.accept_new_submission! self
  end

  def try_evaluate_against!(*)
    {status: :pending, result: nil}
  end
end
