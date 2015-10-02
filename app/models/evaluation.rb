class Evaluation
  attr_reader :assignment, :submission

  def initialize(assignment, submission)
    @assignment = assignment
    @submission = submission
  end

  def run!
    setup_assignment!
    evaluate!.tap do |results|
      save_results! results
    end
  end

  def save_results!(results)
    submission.save_results! results, assignment
  end

  def evaluate!
    submission.evaluate_against! assignment.exercise
  end

  def setup_assignment!
    submission.setup_assignment! assignment
  end
end