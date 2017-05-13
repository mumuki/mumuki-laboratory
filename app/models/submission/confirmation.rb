class Confirmation < Submission
  def setup_assignment!(assignment)
    assignment.accept_new_submission! self
  end

  def try_evaluate_against!(*)
    raise 'Confirmations are not evaluable'
  end
end
