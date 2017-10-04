class Question < Submission
  def run!(assignment, evaluation)
    return [assignment, nil] unless assignment.new_record?
    super
  end

  def save_submission!(assignment)
    assignment.persist_submission! self
  end

  def try_evaluate_exercise!(*)
    {status: :pending, result: nil}
  end
end
