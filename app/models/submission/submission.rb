require 'securerandom'

class Submission
  include ActiveModel::Model

  required :try_evaluate_against!

  def run!(assignment, evaluation)
    setup_assignment! assignment
    results = evaluation.evaluate!(assignment, self)
    save_results! results, assignment
    notify_results! results, assignment
    results
  end

  def evaluate_against!(assignment)
    try_evaluate_against! assignment
  rescue => e
    {status: :errored, result: e.message}
  end

  def id
    @id ||= SecureRandom.hex(8)
  end

  private

  def setup_assignment!(assignment)
    assignment.solution = content
    assignment.save!
  end

  def save_results!(results, assignment)
    assignment.update! results
  end

  def notify_results!(results, assignment)
    assignment.notify!
  end
end
