require 'securerandom'

class Submission
  include ActiveModel::Model

  required :try_evaluate!

  attr_accessor :solution, :status, :result, :expectation_results, :feedback, :test_results,
                :submission_id, :queries, :query_results, :manual_evaluation_comment

  def self.initialize_submission(solution, status, result, expectation_results, feedback, test_results, submission_id, queries, query_results, manual_evaluation_comment)
    new(solution: solution, status: status, result: result, expectation_results: expectation_results, feedback: feedback,
          test_results: test_results, submission_id: submission_id, queries: queries, query_results: query_results,
          manual_evaluation_comment: manual_evaluation_comment)
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
    assignment.assign_attributes results
    assignment.increment_attemps!
    assignment.save! results
  end

  def notify_results!(results, assignment)
    assignment.notify!
  end
end
