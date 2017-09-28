require 'securerandom'

class Submission
  required :try_evaluate_against!

  def id
    @id ||= SecureRandom.hex(8)
  end

  def setup_assignment!(assignment)
    assignment.solution = content
    assignment.save!
  end

  def evaluate_against!(exercise)
    try_evaluate_against! exercise
  rescue => e
    {status: :errored, result: e.message}
  end

  def save_results!(results, assignment)
    assignment.update! results
  end

  def notify_results!(results, assignment)
    assignment.notify!
  end
end
