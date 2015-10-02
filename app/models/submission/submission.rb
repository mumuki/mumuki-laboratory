require 'securerandom'

class Submission
  def id
    @id ||= SecureRandom.hex(8)
  end

  def setup_assignment!(assignment)
    assignment.save!
  end

  def evaluate_against!(exercise)
    try_evaluate_against! exercise
  rescue => e
    {status: :errored, result: e.message}
  end
end