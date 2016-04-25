class Solution < Submission
  include ActiveModel::Model

  attr_accessor :content

  def try_evaluate_against!(exercise)
    exercise.run_tests!(content: content).except(:response_type)
  end

  def setup_assignment!(assignment)
    assignment.rerun!
    super
    assignment.accept_new_submission! self
  end

  def save_results!(results, assignment)
    assignment.update! results
    EventSubscriber.notify! Event::Submission.new(assignment)
  end
end
