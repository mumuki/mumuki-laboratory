require 'securerandom'

class Submission
  include ActiveModel::Model

  required :try_evaluate!

  ATTRIBUTES = [:solution, :status, :result, :expectation_results, :feedback, :test_results,
                :submission_id, :queries, :query_results, :manual_evaluation_comment]

  attr_accessor *ATTRIBUTES

  def self.from_attributes(*args)
    new ATTRIBUTES.zip(args).to_h
  end

  def self.mapping_attributes
    ATTRIBUTES
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
