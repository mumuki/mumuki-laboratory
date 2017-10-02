class Step < Submission
  attr_accessor :value

  def try_evaluate_against!(assignment)
    assignment.seek_goal!(step: value).except(:response_type)
  end

  def setup_assignment!(assignment)
    assignment.running!
    super
    assignment.accept_new_submission! self
  end
end
