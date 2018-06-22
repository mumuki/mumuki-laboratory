require 'securerandom'

class Submission
  include ActiveModel::Model

  required :try_evaluate!
  attr_accessor :test_results, :status, :solution, :result, :expectation_results, :feedback

  def self.initialize_submission(test_results, status, solution, result, expectation_results, feedback)
    new(test_results: test_results, status: status, solution: solution, result: result, expectation_results: expectation_results, feedback: feedback)
  end

  def run!(assignment, evaluation)
    save_submission! assignment
    results = evaluation.evaluate! assignment, self
    save_results! results, assignment
    notify_results! results, assignment
    results
  end

  def evaluate!(assignment)
    try_evaluate! assignment
  rescue => e
    {status: :errored, result: e.message}
  end

  def id
    @id ||= SecureRandom.hex(8)
  end

  private

  def save_submission!(assignment)
    assignment.content = content
    assignment.save!
  end

  def save_results!(results, assignment)
    assignment.update! results
  end

  def notify_results!(results, assignment)
    assignment.notify!
  end
end
