class Evaluation
  attr_reader :assignment, :submission

  def initialize(assignment, submission)
    @assignment = assignment
    @submission = submission
  end

  def run!
    submission.setup_assignment! assignment
    results = submission.evaluate_against! assignment.exercise
    submission.save_results! results, assignment
    results
  end
end