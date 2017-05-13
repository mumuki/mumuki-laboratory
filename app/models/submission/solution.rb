class Solution < Submission
  include ActiveModel::Model

  attr_accessor :content

  def try_evaluate_against!(exercise)
    exercise.run_tests!(content: content).except(:response_type)
  end

  def setup_assignment!(assignment)
    assignment.running!
    super
    assignment.accept_new_submission! self
  end

  def save_results!(results, assignment)
    super
    assignment.notify!
  end
end
